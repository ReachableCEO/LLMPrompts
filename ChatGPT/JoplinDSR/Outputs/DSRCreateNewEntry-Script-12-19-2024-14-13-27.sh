#!/bin/bash
# Copyright ReachableCEO Enterprises 2025
# Licensed under the AGPL v3.0

set -euo pipefail
IFS=$'\n\t'

# Enable logging
log_file="LOG-DSRCreateNewEntry-12-19-2024-14-13-27.log"
exec > >(tee -a "$log_file") 2>&1

function log_message()

{

    echo "$(date '+%m-%d-%Y-%H-%M-%S') $1"

}

function error_exit()

{

    echo -e "\033[0;31mERROR: $1\033[0m" >&2
    log_message "ERROR: $1"
    exit 1

}

# Trap for cleanup on script exit
trap "error_exit 'Script interrupted or an error occurred.'" ERR

# Read and verify environment variables
env_file="../../DSRVariables.env"
if [[ ! -f "$env_file" ]]; then
    error_exit "Environment file $env_file not found."
fi

source "$env_file"

: "${JOPLIN_HOST:?Environment variable JOPLIN_HOST is not set}"
: "${JOPLIN_PORT:?Environment variable JOPLIN_PORT is not set}"
: "${JOPLIN_SOURCE_NOTE_TITLE:?Environment variable JOPLIN_SOURCE_NOTE_TITLE is not set}"
: "${JOPLIN_TARGET_NOTEBOOK:?Environment variable JOPLIN_TARGET_NOTEBOOK is not set}"

# Authenticate and set Joplin token
function get_joplin_apikey()

{

    bw config server https://pwvault.turnsys.com
    echo "Sourcing clientid/apikey data..."
    source D:/tsys/secrets/bitwarden/data/apikey-bitwarden-reachableceo
    bw login --apikey $BW_CLIENTID $BW_CLIENTSECRET
    export BW_SESSION="$(bw unlock --passwordenv TSYS_BW_PASSWORD_REACHABLECEO --raw)"
    export JOPLIN_TOKEN="$(bw get password APIKEY-Joplin-Streaming)"

}

get_joplin_apikey

: "${JOPLIN_TOKEN:?Joplin API key is not set}"

# Find the ID of the source note
function find_note_id()

{

    local page=1
    local note_id
    while true; do
        response=$(curl -s "http://${JOPLIN_HOST}:${JOPLIN_PORT}/notes?token=${JOPLIN_TOKEN}&page=${page}")
        note_id=$(echo "$response" | jq -r --arg title "$JOPLIN_SOURCE_NOTE_TITLE" '.items[] | select(.title == $title) | .id')
        if [[ -n "$note_id" ]]; then
            echo "$note_id"
            return
        fi
        if [[ "$(echo "$response" | jq -r '.has_more')" == "false" ]]; then
            break
        fi
        ((page++))
    done

    error_exit "Source note titled '$JOPLIN_SOURCE_NOTE_TITLE' not found."

}

note_id=$(find_note_id)

# Clone the note to the target notebook
function clone_note()

{

    local cloned_note_title="DSR-$(date '+%m-%d-%Y')"
    curl -s -X POST "http://${JOPLIN_HOST}:${JOPLIN_PORT}/notes?token=${JOPLIN_TOKEN}"         -H "Content-Type: application/json"         --data @<(cat <<EOF
{
    "title": "$cloned_note_title",
    "body": "$(curl -s "http://${JOPLIN_HOST}:${JOPLIN_PORT}/notes/${note_id}?fields=body&token=${JOPLIN_TOKEN}" | jq -r '.body')",
    "parent_id": "$(curl -s "http://${JOPLIN_HOST}:${JOPLIN_PORT}/folders?token=${JOPLIN_TOKEN}" | jq -r --arg name "$JOPLIN_TARGET_NOTEBOOK" '.items[] | select(.title == $name) | .id')"
}
EOF
        ) || error_exit "Failed to clone note."

    log_message "Cloned note titled '$JOPLIN_SOURCE_NOTE_TITLE' to '$cloned_note_title' in notebook '$JOPLIN_TARGET_NOTEBOOK'."

}

clone_note
