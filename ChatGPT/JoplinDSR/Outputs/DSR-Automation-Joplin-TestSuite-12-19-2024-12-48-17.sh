#!/bin/bash

# Test Suite for DSR-Automation-Joplin
set -euo pipefail

echo "Testing environment file sourcing..."
source ../../DSRVariables.env || { echo "Failed to source environment file."; exit 1; }

echo "Testing API key retrieval..."
bash /mnt/data/DSR-Automation-Joplin-Script-12-19-2024-12-48-17.sh || { echo "Script failed."; exit 1; }
