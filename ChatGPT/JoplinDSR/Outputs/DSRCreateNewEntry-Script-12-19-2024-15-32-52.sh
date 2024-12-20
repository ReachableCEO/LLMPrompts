#!/bin/bash
# Copyright (C) ReachableCEO Enterprises 2025
# Licensed under the GNU Affero General Public License v3.0

# Enable strict mode for robust error handling
set -euo pipefail
IFS=$'\n\t'
trap 'echo -e "\e[31m[ERROR] An error occurred. Exiting...\e[0m"; exit 1' ERR

# Log file setup
LOG_FILE="LOG-DSRCreateNewEntry-12-19-2024-15-32-52.log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "$(date +"%m-%d-%Y-%H-%M-%S") [INFO] Script started"

# Variables
ENV_FILE="../../DSRVariables.env"
if [[ ! -f $ENV_FILE ]]; then
    echo "$(date +"%m-%d-%Y-%H-%M-%S") [ERROR] Environment file $ENV_FILE not found." >&2
    exit 1
fi
source "$ENV_FILE"

# Check environment variables
: "${JOPLIN_HOST:?Environment variable JOPLIN_HOST not set or null}"
: "${JOPLIN_PORT:?Environment variable JOPLIN_PORT not set or null}"
: "${JOPLIN_SOURCE_NOTE_TITLE:?Environment variable JOPLIN_SOURCE_NOTE_TITLE not set or null}"
: "${JOPLIN_TARGET_NOTEBOOK:?Environment variable JOPLIN_TARGET_NOTEBOOK not set or null}"

# Functions
get_joplin_apikey() {
    echo "$(date +"%m-%d-%Y-%H-%M-%S") [INFO] Initializing Joplin API key..."
    
    bw logout
    bw config server https://pwvault.turnsys.com
    echo "Sourcing clientid/apikey data..."
    source D:/tsys/secrets/bitwarden/data/apikey-bitwarden-reachableceo
    bw login --apikey $BW_CLIENTID $BW_CLIENTSECRET
    export BW_SESSION="$(bw unlock --passwordenv TSYS_BW_PASSWORD_REACHABLECEO --raw)"
    export JOPLIN_TOKEN="$(bw get password APIKEY-Joplin-Streaming)"

    if [[ -z $JOPLIN_TOKEN ]]; then
        echo "$(date +"%m-%d-%Y-%H-%M-%S") [ERROR] Joplin token is null." >&2
        exit 1
    fi
}

get_note_id() {
    local note_title=$1
    local note_id
    local page=1
    local result

    echo "$(date +"%m-%d-%Y-%H-%M-%S") [INFO] Retrieving note ID for title: $note_title"

    while :; do
        result=$(curl -s "http://${JOPLIN_HOST}:${JOPLIN_PORT}/notes?limit=100&page=${page}&fields=id,title" -H "Authorization: $JOPLIN_TOKEN")
        note_id=$(echo "$result" | jq -r --arg title "$note_title" '.items[] | select(.title == $title) | .id')

        if [[ -n $note_id ]]; then
            echo "$note_id"
            return 0
        fi

        local has_more=$(echo "$result" | jq -r '.has_more')
        if [[ "$has_more" != "true" ]]; then
            break
        fi

        ((page++))
    done

    echo "$(date +"%m-%d-%Y-%H-%M-%S") [ERROR] Note with title '$note_title' not found." >&2
    exit 1
}

clone_note_body() {
    local source_note_id=$1
    local target_notebook=$2
    local date_suffix
    local new_note_title
    local note_body

    date_suffix=$(date +"%m-%d-%Y")
    new_note_title="DSR-${date_suffix}"

    echo "$(date +"%m-%d-%Y-%H-%M-%S") [INFO] Cloning note body to new note titled: $new_note_title"

    note_body=$(curl -s "http://${JOPLIN_HOST}:${JOPLIN_PORT}/notes/${source_note_id}" -H "Authorization: $JOPLIN_TOKEN" | jq -r '.body')

    if [[ -z $note_body ]]; then
        echo "$(date +"%m-%d-%Y-%H-%M-%S") [ERROR] Failed to retrieve body of the source note." >&2
        exit 1
    fi

    curl -s -X POST "http://${JOPLIN_HOST}:${JOPLIN_PORT}/notes"         -H "Authorization: $JOPLIN_TOKEN"         --data-urlencode "title=${new_note_title}"         --data-urlencode "body=${note_body}"         --data-urlencode "parent_id=${target_notebook}"

    echo "$(date +"%m-%d-%Y-%H-%M-%S") [INFO] New note created successfully."
}

# Main script execution
get_joplin_apikey

SOURCE_NOTE_ID=$(get_note_id "$JOPLIN_SOURCE_NOTE_TITLE")
clone_note_body "$SOURCE_NOTE_ID" "$JOPLIN_TARGET_NOTEBOOK"

echo "$(date +"%m-%d-%Y-%H-%M-%S") [INFO] Script completed successfully."
