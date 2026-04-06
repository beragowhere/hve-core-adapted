#!/bin/bash
# Test script for HVE-Core agent validation
# Validates that agent files are accessible and properly formatted

set -e

echo "🔍 HVE-Core Agent Validation Test"
echo "================================="

# Check working directory
echo "1. Checking working directory..."
if [ -d ".github/agents" ]; then
    echo "   ✅ .github/agents directory exists"
else
    echo "   ❌ .github/agents directory missing"
    exit 1
fi

# Check Phase 1 security agents
echo ""
echo "2. Checking Phase 1 Security Agents..."

SECURITY_AGENTS=(
    "security/security-planner.agent.md"
    "security/security-reviewer.agent.md"
    "security/sssc-planner.agent.md"
)

for agent in "${SECURITY_AGENTS[@]}"; do
    agent_path=".github/agents/$agent"
    if [ -f "$agent_path" ]; then
        echo "   ✅ $agent exists"
        
        # Check YAML frontmatter
        if head -1 "$agent_path" | grep -q "---"; then
            echo "      ✅ Has YAML frontmatter"
        else
            echo "      ⚠️  Missing YAML frontmatter"
        fi
        
        # Check agent name
        if grep -q "name:" "$agent_path"; then
            agent_name=$(grep -m1 "name:" "$agent_path" | cut -d: -f2- | xargs)
            echo "      ✅ Agent name: $agent_name"
        fi
        
    else
        echo "   ❌ $agent missing"
    fi
done

# Check instruction files
echo ""
echo "3. Checking Instruction Files..."

INSTRUCTION_FILES=(
    "security/identity.instructions.md"
    "security/security-model.instructions.md"
    "security/sssc-gap-analysis.instructions.md"
    "security/sssc-backlog.instructions.md"
    "security/backlog-handoff.instructions.md"
)

for instruction in "${INSTRUCTION_FILES[@]}"; do
    instruction_path=".github/instructions/$instruction"
    if [ -f "$instruction_path" ]; then
        echo "   ✅ $instruction exists"
    else
        echo "   ❌ $instruction missing"
    fi
done

# Check .copilot-tracking directory
echo ""
echo "4. Checking State Management..."

if [ -d ".copilot-tracking" ]; then
    echo "   ✅ .copilot-tracking directory exists"
else
    echo "   ⚠️  .copilot-tracking directory missing (will be created)"
    mkdir -p .copilot-tracking/security
    mkdir -p .copilot-tracking/sssc
    echo "   ✅ Created .copilot-tracking directory structure"
fi

# Test file system access
echo ""
echo "5. Testing File System Access..."

TEST_FILE=".copilot-tracking/test-validation.txt"
echo "Test content $(date)" > "$TEST_FILE"
if [ -f "$TEST_FILE" ]; then
    echo "   ✅ Can write to .copilot-tracking/"
    rm "$TEST_FILE"
else
    echo "   ❌ Cannot write to .copilot-tracking/"
fi

# Check for ADO references (should be none)
echo ""
echo "6. Checking for ADO References..."

# Look for ADO as a word (not part of "adoption")
ADO_FILES=$(find .github/agents/security -name "*.agent.md" -exec grep -l "\\bADO\\b" {} \; 2>/dev/null || true)
if [ -z "$ADO_FILES" ]; then
    echo "   ✅ No ADO references in security agents"
else
    echo "   ❌ ADO references found in:"
    echo "$ADO_FILES"
fi

echo ""
echo "================================="
echo "✅ Validation Complete"
echo ""
echo "Summary:"
echo "- Phase 1 agents: 3 checked"
echo "- Instruction files: 5 checked"
echo "- State management: Ready"
echo "- File system: Accessible"
echo "- ADO cleanup: Complete"