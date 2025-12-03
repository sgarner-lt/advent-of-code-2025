#!/bin/bash

# Script to mark Carbon tasks as complete in tasks.md

TASKS_FILE="/Users/sgarner/projects/sgarner-lt/advent-of-code-2025/agent-os/specs/2025-12-03-language-toolchain-setup/tasks.md"

# Use sed to update the checkboxes for Carbon tasks
sed -i '' \
    -e '182s/- \[ \] 5.0 Complete Carbon/- [x] 5.0 Complete Carbon/' \
    -e '183s/  - \[ \] 5.1 Create Carbon/  - [x] 5.1 Create Carbon/' \
    -e '194s/  - \[ \] 5.2 Create Carbon/  - [x] 5.2 Create Carbon/' \
    -e '198s/  - \[ \] 5.3 Verify Carbon/  - [x] 5.3 Verify Carbon/' \
    -e '203s/  - \[ \] 5.4 Create Carbon/  - [x] 5.4 Create Carbon/' \
    -e '211s/  - \[ \] 5.5 Troubleshoot Carbon/  - [x] 5.5 Troubleshoot Carbon/' \
    "${TASKS_FILE}"

echo "Carbon tasks marked as complete in tasks.md"
