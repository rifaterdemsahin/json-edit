# JSON Edit

A practical project for editing JSON files using the [JQ](https://stedolan.github.io/jq/) library.

## Overview

This project provides shell scripts and examples for common JSON editing operations using `jq`, a lightweight and flexible command-line JSON processor.

## Prerequisites

- **jq** - Install with:
  - Ubuntu/Debian: `sudo apt-get install jq`
  - macOS: `brew install jq`
  - Windows: `choco install jq`

## Project Structure

```
json-edit/
├── README.md
├── data/
│   └── sample.json      # Sample JSON data for testing
└── scripts/
    ├── json-edit.sh     # Demo script showing various JQ operations
    └── json-util.sh     # Utility script for common JSON operations
```

## Quick Start

### Run Demo Script

```bash
./scripts/json-edit.sh
```

This demonstrates 10 common JQ operations:
1. Read specific fields
2. Read nested fields
3. List array elements
4. Filter by conditions
5. Update fields
6. Add to arrays
7. Delete fields
8. Update nested objects
9. Append to arrays
10. Count elements

### Using the Utility Script

```bash
# Read a value
./scripts/json-util.sh read sample.json .name

# Update a value
./scripts/json-util.sh update sample.json '.settings.theme' '"light"'

# Delete a key
./scripts/json-util.sh delete sample.json '.settings.notifications.sms'

# Add to array
./scripts/json-util.sh add-array sample.json '.tags' '"new-tag"'

# Pretty print
./scripts/json-util.sh pretty sample.json
```

## Common JQ Commands

### Reading Data

```bash
# Get entire JSON
jq '.' file.json

# Get specific field
jq '.name' file.json

# Get nested field
jq '.settings.theme' file.json

# Get array element
jq '.users[0]' file.json

# Get all array elements
jq '.users[]' file.json
```

### Filtering Data

```bash
# Filter by condition
jq '.users[] | select(.active == true)' file.json

# Filter by string match
jq '.users[] | select(.name == "Alice")' file.json
```

### Modifying Data

```bash
# Update field (outputs to stdout)
jq '.settings.theme = "dark"' file.json

# Update field in place
jq '.settings.theme = "dark"' file.json > temp.json && mv temp.json file.json

# Add to array
jq '.tags += ["new-tag"]' file.json

# Delete field
jq 'del(.settings.notifications.sms)' file.json
```

### Transforming Data

```bash
# Get only specific fields
jq '.users[] | {name, email}' file.json

# Map array
jq '[.users[] | .name]' file.json

# Count elements
jq '.users | length' file.json
```

## Sample Data

The project includes a sample JSON file (`data/sample.json`) with:
- Basic metadata (name, version, description)
- User array with nested objects
- Settings object with nested configuration
- Tags array

## License

MIT
