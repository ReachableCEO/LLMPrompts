#!/bin/bash
# Copyright (C) 2024 ReachableCEO Enterprises LLC
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Strict mode and error handling
set -euo pipefail
trap 'echo -e "\033[0;31mError occurred. Exiting.\033[0m"; exit 1' ERR

# Variables
ENV_FILE=""
LOG_FILE="LOG-JoplinDSR-$(date +'%m%d%Y-%H%M%S').log"

# Function to log messages
log_message() {
    echo -e "$(date +'%m-%d-%Y:%H:%M:%S') $1" | tee -a "$LOG_FILE"
}

# Load environment variables
if [[ -z "$ENV_FILE" ]]; then
    log_message "\033[0;31mEnvironment file is not defined.\033[0m"
    exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
    log_message "\033[0;31mEnvironment file does not exist.\033[0m"
    exit 1
fi

source "$ENV_FILE"

# Check required environment variables
for var in JOPLIN_HOST JOPLIN_PORT JOPLIN_SOURCE_NOTE_TITLE JOPLIN_TARGET_NOTEBOOK; do
    if [[ -z "${!var:-}" ]]; then
        log_message "\033[0;31mEnvironment variable $var is not set or empty.\033[0m"
        exit 1
    fi
done

# Skeleton function for API key retrieval
function get_joplin_apikey()

{

    export JOPLIN_TOKEN=""
}

get_joplin_apikey

if [[ -z "$JOPLIN_TOKEN" ]]; then
    log_message "\033[0;31mJOPLIN_TOKEN is not set.\033[0m"
    exit 1
fi

# Find source note ID using the Joplin API
function get_note_id()

{

    local query_url="http://$JOPLIN_HOST:$JOPLIN_PORT/notes?query=$JOPLIN_SOURCE_NOTE_TITLE"
    local page=1
    local note_id=""

    while :; do
        response=$(curl -s "${query_url}&page=$page" -H "Authorization: $JOPLIN_TOKEN")
        ids=$(echo "$response" | jq -r '.items[] | select(.title == "'"$JOPLIN_SOURCE_NOTE_TITLE"'") | .id')
        if [[ -n "$ids" ]]; then
            note_id="$ids"
            break
        fi

        has_more=$(echo "$response" | jq -r '.has_more')
        if [[ "$has_more" != "true" ]]; then
            break
        fi

        ((page++))
    done

    if [[ -z "$note_id" ]]; then
        log_message "\033[0;31mSource note not found.\033[0m"
        exit 1
    fi

    echo "$note_id"
}

source_note_id=$(get_note_id)

# Clone the source note to a new note in the target notebook
function clone_note()

{

    local clone_url="http://$JOPLIN_HOST:$JOPLIN_PORT/notes"
    local target_notebook_id
    target_notebook_id=$(curl -s "http://$JOPLIN_HOST:$JOPLIN_PORT/folders?query=$JOPLIN_TARGET_NOTEBOOK" -H "Authorization: $JOPLIN_TOKEN" | jq -r '.items[] | select(.title == "'"$JOPLIN_TARGET_NOTEBOOK"'") | .id')

    if [[ -z "$target_notebook_id" ]]; then
        log_message "\033[0;31mTarget notebook not found.\033[0m"
        exit 1
    fi

    local note_body
    note_body=$(curl -s "http://$JOPLIN_HOST:$JOPLIN_PORT/notes/$source_note_id" -H "Authorization: $JOPLIN_TOKEN" | jq -r '.body')

    curl -s -X POST "$clone_url" -H "Authorization: $JOPLIN_TOKEN" -H "Content-Type: application/json" -d @- <<EOF
{{
    "title": "DSR-$(date +'%m-%d-%Y')",
    "body": "$note_body",
    "parent_id": "$target_notebook_id"
}}
EOF

    log_message "\033[0;32mNote cloned successfully.\033[0m"
}

clone_note
