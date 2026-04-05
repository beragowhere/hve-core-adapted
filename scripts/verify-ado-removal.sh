#!/bin/bash
# Verify ADO removal completeness
# Exit 0 if no ADO functionality remains, 1 if any found

set -e

echo "🔍 Checking for ADO functionality in HVE‑Core adapted..."

FOUND=0

# Check for ADO directories (actual functionality)
echo "  Checking for ADO directories..."
ADO_DIRS=(
  "collections/ado"
  ".github/agents/ado"
  ".github/prompts/ado"
  ".github/instructions/ado"
  "plugins/ado"
  "docs/agents/ado-backlog"
)

for dir in "${ADO_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo "❌ ADO directory still exists: $dir"
    FOUND=1
  fi
done

# Check package.json for direct azure-devops-node-api dependency
if [ -f "package.json" ]; then
  if grep -q "azure-devops-node-api" package.json; then
    echo "❌ azure-devops-node-api found in package.json (direct dependency)"
    FOUND=1
  fi
fi

# Check for ADO collection files
if find collections -name "*ado*" -type f 2>/dev/null | grep -q .; then
  echo "❌ ADO collection files found"
  find collections -name "*ado*" -type f 2>/dev/null | head -5
  FOUND=1
fi

# Check for ADO agent files
if find .github/agents -name "*ado*" -type f 2>/dev/null | grep -q .; then
  echo "❌ ADO agent files found"
  find .github/agents -name "*ado*" -type f 2>/dev/null | head -5
  FOUND=1
fi

if [ $FOUND -eq 0 ]; then
  echo "✅ No ADO functionality found. Removal complete."
  echo "   Note: Historical references in documentation may remain."
  exit 0
else
  echo ""
  echo "❌ ADO functionality remains."
  echo "   Please clean up before proceeding."
  exit 1
fi