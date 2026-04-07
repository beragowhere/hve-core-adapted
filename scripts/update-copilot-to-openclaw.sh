#!/bin/bash
# Script to update Copilot references to OpenClaw in HVE-Core files

set -e

echo "=== Updating Copilot references to OpenClaw ==="
echo "Working directory: $(pwd)"
echo

# Define replacement patterns (longer patterns first to avoid conflicts)
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

# Find all markdown, yaml, yml files
echo "Finding files to update..."
FILES=$(find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.yaml" \) \
    -not -path "./node_modules/*" \
    -not -path "./.git/*" \
    -not -path "./.github/workflows/*.md.disabled" \
    | sort)

echo "Found $(echo "$FILES" | wc -l) files to process"
echo

# Process each file
UPDATED_COUNT=0
TOTAL_FILES=0

for file in $FILES; do
    TOTAL_FILES=$((TOTAL_FILES + 1))
    
    # Check if file contains any Copilot references
    if grep -qi "copilot" "$file"; then
        echo "Processing: $file"
        
        # Create backup
        cp "$file" "$file.bak"
        
        # Apply replacements
        TEMP_FILE=$(mktemp)
        cp "$file" "$TEMP_FILE"
        
        for replacement_pair in "${replacements[@]}"; do
            pattern="${replacement_pair%|*}"
            replacement="${replacement_pair#*|}"
            # Use sed with proper escaping
            sed -i "s|${pattern}|${replacement}|gI" "$TEMP_FILE"
        done
        
        # Check if changes were made
        if ! diff -q "$file" "$TEMP_FILE" > /dev/null; then
            mv "$TEMP_FILE" "$file"
            UPDATED_COUNT=$((UPDATED_COUNT + 1))
            echo "  ✓ Updated"
            
            # Show sample changes
            echo "  Sample changes:"
            diff -u "$file.bak" "$file" | grep -E "^[-+].*[Cc]opilot.*|^[-+].*[Oo]pen[Cc]law.*" | head -5 | sed 's/^/    /'
        else
            rm "$TEMP_FILE"
            echo "  No changes needed"
        fi
        
        # Clean up backup
        rm "$file.bak"
    fi
done

echo
echo "=== Summary ==="
echo "Total files scanned: $TOTAL_FILES"
echo "Files updated: $UPDATED_COUNT"
echo
echo "Note: This script handles common patterns. Manual review may be needed for:"
echo "1. Context-specific references"
echo "2. Code examples with Copilot"
echo "3. Documentation of Copilot-specific features"
echo
echo "Next steps:"
echo "1. Review updated files"
echo "2. Test functionality"
echo "3. Update .github/CUSTOM-AGENTS.md"