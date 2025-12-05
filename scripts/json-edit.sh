#!/bin/bash

# JSON Edit Script using JQ
# This script demonstrates various JSON editing operations using jq

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="${SCRIPT_DIR}/../data"
INPUT_FILE="${DATA_DIR}/sample.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed. Please install it first.${NC}"
    echo "Install with: apt-get install jq (Debian/Ubuntu)"
    echo "            : brew install jq (macOS)"
    exit 1
fi

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo -e "${RED}Error: Input file not found: $INPUT_FILE${NC}"
    exit 1
fi

print_header "Original JSON"
jq '.' "$INPUT_FILE"

print_header "1. Read specific field (name)"
jq '.name' "$INPUT_FILE"

print_header "2. Read nested field (theme in settings)"
jq '.settings.theme' "$INPUT_FILE"

print_header "3. List all user names"
jq '.users[].name' "$INPUT_FILE"

print_header "4. Filter active users"
jq '.users[] | select(.active == true)' "$INPUT_FILE"

print_header "5. Update a field (change theme to 'light')"
jq '.settings.theme = "light"' "$INPUT_FILE"

print_header "6. Add a new user"
jq '.users += [{"id": 4, "name": "Diana", "email": "diana@example.com", "active": true}]' "$INPUT_FILE"

print_header "7. Delete a field (remove sms from notifications)"
jq 'del(.settings.notifications.sms)' "$INPUT_FILE"

print_header "8. Update user by ID (set Bob to active)"
jq '(.users[] | select(.id == 2)).active = true' "$INPUT_FILE"

print_header "9. Add a new tag"
jq '.tags += ["automation"]' "$INPUT_FILE"

print_header "10. Get count of users"
jq '.users | length' "$INPUT_FILE"

echo -e "\n${GREEN}All operations completed successfully!${NC}"
