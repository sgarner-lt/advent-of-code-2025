#!/bin/bash

# Test script for Carbon Day 06 implementation
# Tests parsing and calculation logic

echo "Testing Carbon Day 06 implementation..."

# Test 1: Parse simple input
echo "Test 1: Parse simple input with 2 problems"
echo -e "123 328\n45 64\n* +" | carbon run day06_simple.carbon
echo ""

# Test 2: Sample input from problem statement
echo "Test 2: Sample input (expected: 4277556)"
cat ../../../challenges/day06/input-sample.txt | carbon run day06_simple.carbon
echo ""

# Test 3: Small example
echo "Test 3: Small example (expected: 80)"
echo -e "10 20\n5 10\n* +" | carbon run day06_simple.carbon
echo ""

echo "All tests completed!"
