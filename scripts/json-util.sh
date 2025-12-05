#!/bin/bash

# JSON Editor Utility - Save Edits to File
# This script demonstrates how to edit JSON and save the changes

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="${SCRIPT_DIR}/../data"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

usage() {
    echo -e "${BLUE}JSON Edit Utility${NC}"
    echo ""
    echo "Usage: $0 <command> <input_file> [options]"
    echo ""
    echo "Commands:"
    echo "  read <file> <path>           - Read a value from JSON path"
    echo "  update <file> <path> <value> - Update a value at JSON path"
    echo "  delete <file> <path>         - Delete a key from JSON"
    echo "  add-array <file> <path> <value> - Add item to array"
    echo "  pretty <file>                - Pretty print JSON"
    echo ""
    echo "Examples:"
    echo "  $0 read sample.json .name"
    echo "  $0 update sample.json '.settings.theme' '\"dark\"'"
    echo "  $0 delete sample.json '.settings.notifications.sms'"
    echo "  $0 add-array sample.json '.tags' '\"new-tag\"'"
    echo "  $0 pretty sample.json"
    exit 1
}

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed${NC}"
    exit 1
fi

if [ $# -lt 2 ]; then
    usage
fi

COMMAND=$1
INPUT_FILE=$2

# Resolve file path
if [ ! -f "$INPUT_FILE" ]; then
    if [ -f "${DATA_DIR}/$INPUT_FILE" ]; then
        INPUT_FILE="${DATA_DIR}/$INPUT_FILE"
    else
        echo -e "${RED}Error: File not found: $INPUT_FILE${NC}"
        exit 1
    fi
fi

case $COMMAND in
    read)
        if [ -z "$3" ]; then
            echo -e "${RED}Error: JSON path required${NC}"
            usage
        fi
        jq "$3" "$INPUT_FILE"
        ;;
    
    update)
        if [ -z "$3" ] || [ -z "$4" ]; then
            echo -e "${RED}Error: Path and value required${NC}"
            usage
        fi
        TEMP_FILE=$(mktemp)
        jq "$3 = $4" "$INPUT_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$INPUT_FILE"
        echo -e "${GREEN}Updated $3 to $4${NC}"
        jq '.' "$INPUT_FILE"
        ;;
    
    delete)
        if [ -z "$3" ]; then
            echo -e "${RED}Error: JSON path required${NC}"
            usage
        fi
        TEMP_FILE=$(mktemp)
        jq "del($3)" "$INPUT_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$INPUT_FILE"
        echo -e "${GREEN}Deleted $3${NC}"
        jq '.' "$INPUT_FILE"
        ;;
    
    add-array)
        if [ -z "$3" ] || [ -z "$4" ]; then
            echo -e "${RED}Error: Path and value required${NC}"
            usage
        fi
        TEMP_FILE=$(mktemp)
        jq "$3 += [$4]" "$INPUT_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$INPUT_FILE"
        echo -e "${GREEN}Added $4 to $3${NC}"
        jq '.' "$INPUT_FILE"
        ;;
    
    pretty)
        jq '.' "$INPUT_FILE"
        ;;
    
    *)
        echo -e "${RED}Unknown command: $COMMAND${NC}"
        usage
        ;;
esac
