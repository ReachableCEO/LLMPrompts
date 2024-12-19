#!/usr/bin/env bash
# Copyright (C) 2025 ReachableCEO Enterprises LLC
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
# You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

set -euo pipefail
trap "echo 'An error occurred. Exiting.'; exit 1" ERR

function read_env_vars()

{

    local env_file="$1"

    if [[ ! -f "$env_file" ]]; then
        echo "Error: Environment file '$env_file' not found."
        exit 1
    fi

    source "$env_file"

    : "${JOPLIN_HOST:?Environment variable JOPLIN_HOST is not set or empty}"
    : "${JOPLIN_PORT:?Environment variable JOPLIN_PORT is not set or empty}"
    : "${JOPLIN_TOKEN:?Environment variable JOPLIN_TOKEN is not set or empty}"
    : "${JOPLIN_SOURCE_NOTE_TITLE:?Environment variable JOPLIN_SOURCE_NOTE_TITLE is not set or empty}"
    : "${JOPLIN_TARGET_NOTEBOOK:?Environment variable JOPLIN_TARGET_NOTEBOOK is not set or empty}"

}

function find_note_id()

{

    local note_title="$1"
    local page=1
    local note_id=""

    while true; do
        local response
        response=$(curl -s --fail "http://$JOPLIN_HOST:$JOPLIN_PORT/notes?token=$JOPLIN_TOKEN&query=$note_title&page=$page")

        echo "$response" | jq -r '.items[] | select(.title == "'"$note_title"'") | .id' | while read -r id; do
            note_id="$id"
            break
        done

        if [[ -n "$note_id" ]]; then
            echo "$note_id"
            return 0
        fi

        if [[ "$(echo "$response" | jq -r '.has_more')" == "false" ]]; then
            echo "Error: Note titled '$note_title' not found."
            exit 1
        fi

        ((page++))
    done

}

function clone_note()

{

    local note_id="$1"
    local target_notebook="$2"
    local new_note_title="DSR-$(date '+%m-%d-%Y')"

    local target_notebook_id
    target_notebook_id=$(curl -s --fail "http://$JOPLIN_HOST:$JOPLIN_PORT/folders?token=$JOPLIN_TOKEN" | jq -r '.items[] | select(.title == "'"$target_notebook"'") | .id')

    if [[ -z "$target_notebook_id" ]]; then
        echo "Error: Target notebook '$target_notebook' not found."
        exit 1
    fi

    local note_body
    note_body=$(curl -s --fail "http://$JOPLIN_HOST:$JOPLIN_PORT/notes/$note_id?token=$JOPLIN_TOKEN" | jq -r '.body')

    curl -s --fail -X POST "http://$JOPLIN_HOST:$JOPLIN_PORT/notes?token=$JOPLIN_TOKEN"         -H "Content-Type: application/json"         --data "{"title":"$new_note_title","body":"$note_body","parent_id":"$target_notebook_id"}"

}

function main()

{

    local env_file="$1"

    read_env_vars "$env_file"
    local note_id
    note_id=$(find_note_id "$JOPLIN_SOURCE_NOTE_TITLE")
    clone_note "$note_id" "$JOPLIN_TARGET_NOTEBOOK"

}

main "$1"
