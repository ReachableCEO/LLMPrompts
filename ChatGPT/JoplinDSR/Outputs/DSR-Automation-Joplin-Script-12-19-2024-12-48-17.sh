#!/bin/bash

# Copyright (c) 2025 ReachableCEO Enterprises LLC
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

set -euo pipefail

# Enable bash strict mode and error handling
trap 'echo -e "\033[31mAn error occurred. Exiting...\033[0m" >&2; exit 1' ERR
LOG_FILE="{log_filename}"
exec > >(tee -a "$LOG_FILE") 2>&1

echo -e "\033[32mStarting DSR Automation Script...\033[0m"
echo "$(date '+%m-%d-%Y-%H-%M-%S') - Script started."

# Variables
ENV_FILE="../../DSRVariables.env"
if [[ ! -f "$ENV_FILE" ]]; then
    echo -e "\033[31mEnvironment file $ENV_FILE not found.\033[0m" >&2
    exit 1
fi

source "$ENV_FILE"

# Ensure required variables are not null
: "${JOPLIN_HOST:?Environment variable JOPLIN_HOST is missing or null.}"
: "${JOPLIN_PORT:?Environment variable JOPLIN_PORT is missing or null.}"
: "${JOPLIN_SOURCE_NOTE_TITLE:?Environment variable JOPLIN_SOURCE_NOTE_TITLE is missing or null.}"
: "${JOPLIN_TARGET_NOTEBOOK:?Environment variable JOPLIN_TARGET_NOTEBOOK is missing or null.}"

# Function to retrieve Joplin API key
function get_joplin_apikey()

{

    echo "$(date '+%m-%d-%Y-%H-%M-%S') - Configuring Bitwarden and fetching Joplin API key."
    bw config server https://pwvault.turnsys.com
    echo "Sourcing clientid/apikey data..."
    source D:/tsys/secrets/bitwarden/data/apikey-bitwarden-reachableceo
    bw login --apikey "$BW_CLIENTID" "$BW_CLIENTSECRET"
    export BW_SESSION="$(bw unlock --passwordenv TSYS_BW_PASSWORD_REACHABLECEO --raw)"
    export JOPLIN_TOKEN="$(bw get password APIKEY-Joplin-Streaming)"

}

get_joplin_apikey

if [[ -z "$JOPLIN_TOKEN" ]]; then
    echo -e "\033[31mJOPLIN_TOKEN is null.\033[0m" >&2
    exit 1
fi

# Fetch source note ID
echo "$(date '+%m-%d-%Y-%H-%M-%S') - Fetching source note ID."
NOTE_ID=$(curl -s "http://$JOPLIN_HOST:$JOPLIN_PORT/notes?query=$JOPLIN_SOURCE_NOTE_TITLE" | jq -r '.items[].id')

if [[ -z "$NOTE_ID" ]]; then
    echo -e "\033[31mSource note not found.\033[0m" >&2
    exit 1
fi

# Clone note to a new note
NEW_NOTE_TITLE="DSR-$(date '+%m-%d-%Y')"
echo "$(date '+%m-%d-%Y-%H-%M-%S') - Cloning note to $NEW_NOTE_TITLE."
NOTE_BODY=$(curl -s "http://$JOPLIN_HOST:$JOPLIN_PORT/notes/$NOTE_ID" | jq -r '.body')

curl -s -X POST "http://$JOPLIN_HOST:$JOPLIN_PORT/notes"     -H "Content-Type: application/json"     --data @- <<EOF
{{
    "title": "$NEW_NOTE_TITLE",
    "body": "$NOTE_BODY",
    "parent_id": "$(curl -s "http://$JOPLIN_HOST:$JOPLIN_PORT/folders?query=$JOPLIN_TARGET_NOTEBOOK" | jq -r '.items[].id')"
}}
EOF

echo -e "\033[32mDSR Automation Script completed successfully.\033[0m"
