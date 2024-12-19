#!/usr/bin/env bash
# Copyright (C) 2025 ReachableCEO Enterprises LLC
# License: AGPL v3.0

set -euo pipefail
trap "echo 'Test failed. Cleaning up.'; exit 1" ERR

function test_read_env_vars()

{

    # Mock environment file
    local mock_env_file="mock_env_vars.env"
    echo -e "JOPLIN_HOST=localhost\nJOPLIN_PORT=41184\nJOPLIN_TOKEN=testtoken\nJOPLIN_SOURCE_NOTE_TITLE=TestNote\nJOPLIN_TARGET_NOTEBOOK=TestNotebook" > "$mock_env_file"

    # Run the function
    ./GPTScript.sh "$mock_env_file"

    echo "test_read_env_vars passed"
}

test_read_env_vars
