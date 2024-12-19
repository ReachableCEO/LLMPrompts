
#!/bin/bash

# Copyright (C) 2025 ReachableCEO Enterprises LLC
# This program is licensed under the AGPL v3.0.

# Exit immediately if a command exits with a non-zero status
# Enable strict error handling
set -euo pipefail

# Log file setup
LOG_FILE="LOG-JoplinDSR-$(date '+%m-%d-%Y-%H:%M:%S').log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "$(date '+%m-%d-%Y:%H:%M:%S') [INFO] Script started."

# Function to print status messages
function print_status()

{

    echo -e "\033[32m$(date '+%m-%d-%Y:%H:%M:%S') [INFO]\033[0m $1"
}

# Function to print error messages and exit
function print_error()

{

    echo -e "\033[31m$(date '+%m-%d-%Y:%H:%M:%S') [ERROR]\033[0m $1"
    exit 1
}

# Skeleton function for retrieving Joplin API key
function get_joplin_apikey()

{

    export JOPLIN_TOKEN=""
}

# Read environment variables
ENV_FILE=""  # Specify the path to your environment file here
if [[ -z "$ENV_FILE" ]]; then
    print_error "ENV_FILE variable is not set."
fi

if [[ ! -f "$ENV_FILE" ]]; then
    print_error "Environment file does not exist."
fi

source "$ENV_FILE"

# Ensure environment variables are set
: "${JOPLIN_HOST:?Environment variable JOPLIN_HOST is not set.}"
: "${JOPLIN_PORT:?Environment variable JOPLIN_PORT is not set.}"
: "${JOPLIN_SOURCE_NOTE_TITLE:?Environment variable JOPLIN_SOURCE_NOTE_TITLE is not set.}"
: "${JOPLIN_TARGET_NOTEBOOK:?Environment variable JOPLIN_TARGET_NOTEBOOK is not set.}"
: "${JOPLIN_TOKEN:?Environment variable JOPLIN_TOKEN is not set.}"

# Function to find the ID of a note
function find_note_id()

{

    local note_title="$1"
    local note_id=""
    local page=1

    while :; do
        response=$(curl -s -X GET "http://$JOPLIN_HOST:$JOPLIN_PORT/notes?query=$note_title&page=$page"             -H "Authorization: $JOPLIN_TOKEN")

        if [[ $? -ne 0 ]]; then
            print_error "Failed to retrieve notes from Joplin API."
        fi

        note_id=$(echo "$response" | jq -r --arg title "$note_title" '.items[] | select(.title == $title) | .id')

        if [[ -n "$note_id" ]]; then
            echo "$note_id"
            return
        fi

        if [[ "$(echo "$response" | jq '.has_more')" != "true" ]]; then
            break
        fi

        ((page++))
    done

    print_error "Note with title '$note_title' not found."
}

# Main logic to clone note
function clone_note()

{

    local source_id
    local target_note_title="DSR-$(date '+%m-%d-%Y')"

    print_status "Finding source note ID..."
    source_id=$(find_note_id "$JOPLIN_SOURCE_NOTE_TITLE")

    print_status "Cloning note body to a new note..."
    response=$(curl -s -X GET "http://$JOPLIN_HOST:$JOPLIN_PORT/notes/$source_id"         -H "Authorization: $JOPLIN_TOKEN")

    if [[ $? -ne 0 ]]; then
        print_error "Failed to retrieve note body."
    fi

    body=$(echo "$response" | jq -r '.body')
    notebook_id=$(curl -s -X GET "http://$JOPLIN_HOST:$JOPLIN_PORT/folders"         -H "Authorization: $JOPLIN_TOKEN" | jq -r --arg notebook "$JOPLIN_TARGET_NOTEBOOK" '.[] | select(.title == $notebook) | .id')

    if [[ -z "$notebook_id" ]]; then
        print_error "Target notebook '$JOPLIN_TARGET_NOTEBOOK' not found."
    fi

    # Create JSON payload in a temporary file
    json_payload=$(mktemp)
    cat > "$json_payload" <<EOF
{{
    "title": "$target_note_title",
    "body": "$body",
    "parent_id": "$notebook_id"
}}
EOF

    curl -s -X POST "http://$JOPLIN_HOST:$JOPLIN_PORT/notes"         -H "Authorization: $JOPLIN_TOKEN"         -H "Content-Type: application/json"         --data-binary @"$json_payload"

    rm -f "$json_payload"

    if [[ $? -ne 0 ]]; then
        print_error "Failed to create cloned note."
    fi

    print_status "Note cloned successfully as '$target_note_title'."
}

# Execution
get_joplin_apikey
clone_note
echo "$(date '+%m-%d-%Y:%H:%M:%S') [INFO] Script completed."
