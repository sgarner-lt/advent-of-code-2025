#!/bin/bash
# Script to update tasks.md and mark Task Group 6 as complete
# Run this after verifying Bosque installation works

TASKS_FILE="$(dirname "$0")/tasks.md"

# Update Task Group 6 checkboxes
sed -i '' '231s/\[ \]/[x]/' "$TASKS_FILE"  # 6.0
sed -i '' '232s/\[ \]/[x]/' "$TASKS_FILE"  # 6.1
sed -i '' '243s/\[ \]/[x]/' "$TASKS_FILE"  # 6.2
sed -i '' '247s/\[ \]/[x]/' "$TASKS_FILE"  # 6.3
sed -i '' '252s/\[ \]/[x]/' "$TASKS_FILE"  # 6.4
sed -i '' '260s/\[ \]/[x]/' "$TASKS_FILE"  # 6.5

echo "Task Group 6 marked as complete in tasks.md"
