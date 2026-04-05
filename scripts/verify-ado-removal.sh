#!/bin/bash
# Verify ADO removal completeness
# Exit 0 if no ADO references, 1 if any found

set -e

echo "🔍 Checking for ADO references in HVE‑Core adapted..."

# Patterns to search (case‑insensitive)
PATTERNS=(
  "ado"
  "azure.*devops"
  "Azure DevOps"
  "azure-devops-node-api"
)

EXCLUDE_DIRS=(
  "node_modules"
  ".git"
  ".github/workflows"  # CI may reference ADO in workflows
)

FOUND=0
TOTAL_MATCHES=0

for pattern in "${PATTERNS[@]}"; do
  echo "  Searching for: '$pattern'"
  
  # Build exclude arguments
  EXCLUDE_ARGS=()
  for dir in "${EXCLUDE_DIRS[@]}"; do
    EXCLUDE_ARGS+=("--exclude-dir=$dir")
  done
  
  matches=$(grep -r -i "${EXCLUDE_ARGS[@]}" "$pattern" . 2>/dev/null | wc -l)
  
  if [ "$matches" -gt 0 ]; then
    echo "❌ Found $matches matches for pattern: $pattern"
    grep -r -i "${EXCLUDE_ARGS[@]}" "$pattern" . 2>/dev/null | head -10
    FOUND=1
    TOTAL_MATCHES=$((TOTAL_MATCHES + matches))
  fi
done

# Special check for ADO directory existence
if [ -d "collections/ado" ] || [ -d ".github/agents/ado" ] || [ -d ".github/prompts/ado" ] || [ -d ".github/instructions/ado" ] || [ -d "plugins/ado" ] || [ -d "docs/agents/ado-backlog" ]; then
  echo "❌ ADO directories still exist:"
  [ -d "collections/ado" ] && echo "  collections/ado/"
  [ -d ".github/agents/ado" ] && echo "  .github/agents/ado/"
  [ -d ".github/prompts/ado" ] && echo "  .github/prompts/ado/"
  [ -d ".github/instructions/ado" ] && echo "  .github/instructions/ado/"
  [ -d "plugins/ado" ] && echo "  plugins/ado/"
  [ -d "docs/agents/ado-backlog" ] && echo "  docs/agents/ado-backlog/"
  FOUND=1
fi

# Check package.json for direct azure-devops-node-api dependency
if [ -f "package.json" ]; then
  if grep -q "azure-devops-node-api" package.json; then
    echo "❌ azure-devops-node-api found in package.json (direct dependency)"
    FOUND=1
  fi
fi
# Note: azure-devops-node-api may exist in package-lock.json as transitive dependency of @vscode/vsce
# That's acceptable as long as it's not a direct dependency.

if [ $FOUND -eq 0 ]; then
  echo "✅ No ADO references found. Removal complete."
  exit 0
else
  echo ""
  echo "❌ ADO references remain ($TOTAL_MATCHES matches)."
  echo "   Please clean up before proceeding."
  exit 1
fi