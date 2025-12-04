#!/usr/bin/env bash
# Validation script for Day 1 Part 2 - Cross-language validation
# This script runs all 5 language implementations against an input file
# and verifies they all produce identical results

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the input file from command line argument
if [ $# -lt 1 ]; then
    echo "Usage: $0 <input_file>"
    echo "Example: $0 input-sample.txt"
    exit 1
fi

INPUT_FILE="$1"

# Get absolute path to input file BEFORE changing directories
if [[ "$INPUT_FILE" = /* ]]; then
    INPUT_PATH="$INPUT_FILE"
else
    INPUT_PATH="$(cd "$(dirname "$INPUT_FILE")" && pwd)/$(basename "$INPUT_FILE")"
fi

# Verify input file exists
if [ ! -f "$INPUT_PATH" ]; then
    echo -e "${RED}Error: Input file '$INPUT_PATH' not found${NC}"
    exit 1
fi

# Get absolute path to project root (2 directories up from this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Day 1 Part 2 - Cross-Language Validation${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Input file: ${YELLOW}$INPUT_PATH${NC}"
echo ""

# Change to project root for runner scripts
cd "$PROJECT_ROOT"

# Array to store results
declare -A results_part1
declare -A results_part2
declare -A statuses

languages=("rust" "gleam" "roc" "carbon" "bosque")

# Run each language implementation
for lang in "${languages[@]}"; do
    echo -e "${BLUE}Running $lang implementation...${NC}"

    # Run the implementation using runner scripts
    output=$(./scripts/runners/run_${lang}.sh 1 "$INPUT_PATH" 2>&1 || true)

    # Check if output contains valid JSON
    if echo "$output" | grep -q '{"part1".*"part2"'; then
        # Extract part1 and part2 values using grep and sed
        part1=$(echo "$output" | grep -o '"part1"[[:space:]]*:[[:space:]]*[0-9]\+' | grep -o '[0-9]\+')
        part2=$(echo "$output" | grep -o '"part2"[[:space:]]*:[[:space:]]*[0-9]\+' | grep -o '[0-9]\+')

        results_part1[$lang]=$part1
        results_part2[$lang]=$part2
        statuses[$lang]="success"

        echo -e "${GREEN}  ✓ Part 1: $part1, Part 2: $part2${NC}"
    else
        statuses[$lang]="failed"
        echo -e "${RED}  ✗ Failed to get valid output${NC}"
        echo -e "${RED}  Output: $output${NC}"
    fi
    echo ""
done

# Validation: Check if all results are identical
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Validation Results${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check for any failures
failed_count=0
for lang in "${languages[@]}"; do
    if [ "${statuses[$lang]}" != "success" ]; then
        echo -e "${RED}✗ $lang: FAILED${NC}"
        failed_count=$((failed_count + 1))
    fi
done

if [ $failed_count -gt 0 ]; then
    echo -e "${RED}ERROR: $failed_count language(s) failed to execute${NC}"
    exit 1
fi

# Get reference values from first successful language
reference_lang=""
reference_part1=""
reference_part2=""

for lang in "${languages[@]}"; do
    if [ "${statuses[$lang]}" = "success" ]; then
        reference_lang=$lang
        reference_part1=${results_part1[$lang]}
        reference_part2=${results_part2[$lang]}
        break
    fi
done

echo -e "Reference implementation: ${YELLOW}$reference_lang${NC}"
echo -e "  Part 1: ${YELLOW}$reference_part1${NC}"
echo -e "  Part 2: ${YELLOW}$reference_part2${NC}"
echo ""

# Compare all results against reference
all_match=true
for lang in "${languages[@]}"; do
    if [ "${statuses[$lang]}" = "success" ]; then
        part1=${results_part1[$lang]}
        part2=${results_part2[$lang]}

        if [ "$part1" = "$reference_part1" ] && [ "$part2" = "$reference_part2" ]; then
            echo -e "${GREEN}✓ $lang: MATCH (part1=$part1, part2=$part2)${NC}"
        else
            echo -e "${RED}✗ $lang: MISMATCH${NC}"
            if [ "$part1" != "$reference_part1" ]; then
                echo -e "${RED}    Part 1: expected $reference_part1, got $part1${NC}"
            fi
            if [ "$part2" != "$reference_part2" ]; then
                echo -e "${RED}    Part 2: expected $reference_part2, got $part2${NC}"
            fi
            all_match=false
        fi
    fi
done

echo ""
echo -e "${BLUE}========================================${NC}"

if $all_match; then
    echo -e "${GREEN}SUCCESS: All implementations produce identical results!${NC}"
    echo -e "${GREEN}Part 1: $reference_part1${NC}"
    echo -e "${GREEN}Part 2: $reference_part2${NC}"
    exit 0
else
    echo -e "${RED}FAILURE: Implementations produce different results${NC}"
    exit 1
fi
