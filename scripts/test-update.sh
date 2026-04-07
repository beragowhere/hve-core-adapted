#!/bin/bash
# Test script for updating Copilot references

set -e

echo "=== Testing replacement logic ==="

# Test content
TEST_CONTENT="HVE Core includes specialized contribution guides for AI artifacts that enhance GitHub Copilot functionality. These artifacts define custom agents, reusable prompts, coding guidelines (instructions), and executable skills."

echo "Original:"
echo "$TEST_CONTENT"
echo

# Define replacements (longer patterns first)
replacements=(
    "VS Code with the GitHub Copilot Chat extension|OpenClaw platform"
    "GitHub Copilot Chat|OpenClaw interface"
    "GitHub Copilot infrastructure|OpenClaw infrastructure"
    "GitHub Copilot audit streams|OpenClaw audit streams"
    "GitHub Copilot Extension|OpenClaw Extension"
    "consumed by GitHub Copilot|consumed by OpenClaw"
    "GitHub Copilot|OpenClaw"
    "Copilot Chat|OpenClaw interface"
    "Copilot actions|OpenClaw workflows"
    "Copilot functionality|OpenClaw functionality"
    "VS Code \+ Copilot|OpenClaw"
)

# Apply replacements
result="$TEST_CONTENT"
for replacement_pair in "${replacements[@]}"; do
    pattern="${replacement_pair%|*}"
    replacement="${replacement_pair#*|}"
    # Use sed
    result=$(echo "$result" | sed "s|${pattern}|${replacement}|gI")
done

echo "After replacement:"
echo "$result"
echo

# Test another example
TEST2="Run the functional review prompt from the Copilot Chat panel:"
echo "Original 2: $TEST2"
result2="$TEST2"
for replacement_pair in "${replacements[@]}"; do
    pattern="${replacement_pair%|*}"
    replacement="${replacement_pair#*|}"
    result2=$(echo "$result2" | sed "s|${pattern}|${replacement}|gI")
done
echo "After replacement 2: $result2"