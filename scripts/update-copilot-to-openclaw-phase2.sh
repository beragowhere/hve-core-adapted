#!/bin/bash
# Phase 2: Update remaining Copilot patterns

set -e

echo "=== Phase 2: Updating remaining Copilot references ==="
echo

# Additional patterns that need escaping or were missed
declare -A patterns=(
    ["VS Code \\+ Copilot"]="OpenClaw"
    ["Copilot following"]="OpenClaw following"
    ["Copilot automatically"]="OpenClaw automatically"
    ["Copilot-specific"]="OpenClaw-specific"
    ["Copilot-based"]="OpenClaw-based"
    ["Copilot-enabled"]="OpenClaw-enabled"
    ["Copilot-integrated"]="OpenClaw-integrated"
    ["Copilot-compatible"]="OpenClaw-compatible"
    ["Copilot agent"]="OpenClaw agent"
    ["Copilot extension"]="OpenClaw extension"
    ["Copilot panel"]="OpenClaw interface"
    ["Copilot window"]="OpenClaw interface"
    ["Copilot sidebar"]="OpenClaw sidebar"
    ["Copilot view"]="OpenClaw view"
)

# Find files that still contain "copilot" (case-insensitive)
echo "Finding files with remaining Copilot references..."
FILES=$(grep -r -l -i "copilot" --include="*.md" --include="*.yml" --include="*.yaml" . \
    | grep -v node_modules \
    | grep -v ".git" \
    | sort)

echo "Found $(echo "$FILES" | wc -l) files with remaining references"
echo

UPDATED_COUNT=0
for file in $FILES; do
    echo "Processing: $file"
    
    # Create backup
    cp "$file" "$file.bak"
    
    # Apply replacements
    TEMP_FILE=$(mktemp)
    cp "$file" "$TEMP_FILE"
    
    CHANGED=false
    for pattern in "${!patterns[@]}"; do
        replacement="${patterns[$pattern]}"
        # Check if pattern exists
        if grep -qi "$pattern" "$TEMP_FILE"; then
            # Use sed with proper escaping
            escaped_pattern=$(printf '%s\n' "$pattern" | sed 's/[\/&]/\\&/g')
            escaped_replacement=$(printf '%s\n' "$replacement" | sed 's/[\/&]/\\&/g')
            sed -i "s/${escaped_pattern}/${escaped_replacement}/gI" "$TEMP_FILE"
            CHANGED=true
        fi
    done
    
    if $CHANGED; then
        mv "$TEMP_FILE" "$file"
        UPDATED_COUNT=$((UPDATED_COUNT + 1))
        echo "  ✓ Updated"
        
        # Show what changed
        echo "  Changes made:"
        diff -u "$file.bak" "$file" | grep -E "^[-+].*[Cc]opilot.*|^[-+].*[Oo]pen[Cc]law.*" | head -3 | sed 's/^/    /'
    else
        rm "$TEMP_FILE"
        echo "  No additional changes needed"
    fi
    
    # Clean up backup
    rm "$file.bak"
done

echo
echo "=== Phase 2 Summary ==="
echo "Files processed: $(echo "$FILES" | wc -l)"
echo "Files updated: $UPDATED_COUNT"
echo
echo "Note: Some Copilot references may be intentional (e.g., in changelog entries)"
echo "or require context-specific updates."