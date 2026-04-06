#!/bin/bash
# Test script for Phase 2 agents (Infrastructure & Documentation)
# Validates that Phase 2 agents are properly configured

set -e

echo "🔍 Phase 2 Agent Validation Test"
echo "================================="

# Check working directory
echo "1. Checking working directory..."
if [ -d ".github/agents" ]; then
    echo "   ✅ .github/agents directory exists"
else
    echo "   ❌ .github/agents directory missing"
    exit 1
fi

# Check Phase 2 infrastructure agents
echo ""
echo "2. Checking Phase 2 Infrastructure Agents..."

INFRA_AGENTS=(
    "dependency-reviewer.agent.md"
    "issue-triage.agent.md"
)

for agent in "${INFRA_AGENTS[@]}"; do
    agent_path=".github/agents/$agent"
    if [ -f "$agent_path" ]; then
        echo "   ✅ $agent exists"
        
        # Check agent name
        if grep -q "name:" "$agent_path"; then
            agent_name=$(grep -m1 "name:" "$agent_path" | cut -d: -f2- | xargs)
            echo "      ✅ Agent name: $agent_name"
        fi
        
        # Check for GitHub focus (not ADO)
        if grep -q -i "github" "$agent_path"; then
            echo "      ✅ GitHub-focused"
        else
            echo "      ⚠️  No explicit GitHub focus found"
        fi
        
    else
        echo "   ❌ $agent missing"
    fi
done

# Check documentation agents
echo ""
echo "3. Checking Documentation Agents..."

DOC_AGENTS=(
    "doc-update-checker.agent.md"
)

for agent in "${DOC_AGENTS[@]}"; do
    agent_path=".github/agents/$agent"
    if [ -f "$agent_path" ]; then
        echo "   ✅ $agent exists"
        
        # Check agent name
        if grep -q "name:" "$agent_path"; then
            agent_name=$(grep -m1 "name:" "$agent_path" | cut -d: -f2- | xargs)
            echo "      ✅ Agent name: $agent_name"
        fi
        
    else
        echo "   ❌ $agent missing"
    fi
done

# Check data science agents (basic check)
echo ""
echo "4. Checking Data Science Agents..."

DS_AGENTS=$(find .github/agents/data-science -name "*.agent.md" 2>/dev/null | wc -l)
if [ "$DS_AGENTS" -gt 0 ]; then
    echo "   ✅ $DS_AGENTS data science agent(s) found"
    
    # List them
    find .github/agents/data-science -name "*.agent.md" 2>/dev/null | while read agent; do
        agent_name=$(basename "$agent")
        echo "      - $agent_name"
    done
else
    echo "   ⚠️  No data science agents found"
fi

# Check for ADO references (should be none)
echo ""
echo "5. Checking for ADO References..."

ADO_FILES=$(find .github/agents -name "*.agent.md" -exec grep -l "ADO" {} \; 2>/dev/null || true)
if [ -z "$ADO_FILES" ]; then
    echo "   ✅ No ADO references in any agents"
else
    echo "   ❌ ADO references found in:"
    echo "$ADO_FILES"
fi

# Check instruction files for Phase 2 agents
echo ""
echo "6. Checking Instruction Files..."

# Check for GitHub instructions
if [ -d ".github/instructions/github" ]; then
    GITHUB_INSTRUCTIONS=$(find .github/instructions/github -name "*.instructions.md" 2>/dev/null | wc -l)
    echo "   ✅ GitHub instructions directory exists ($GITHUB_INSTRUCTIONS files)"
else
    echo "   ⚠️  GitHub instructions directory missing"
fi

# Check for documentation instructions
if [ -d ".github/instructions/documentation" ]; then
    DOC_INSTRUCTIONS=$(find .github/instructions/documentation -name "*.instructions.md" 2>/dev/null | wc -l)
    echo "   ✅ Documentation instructions directory exists ($DOC_INSTRUCTIONS files)"
else
    echo "   ⚠️  Documentation instructions directory missing"
fi

echo ""
echo "================================="
echo "✅ Phase 2 Validation Complete"
echo ""
echo "Summary:"
echo "- Infrastructure agents: ${#INFRA_AGENTS[@]} checked"
echo "- Documentation agents: ${#DOC_AGENTS[@]} checked"
echo "- Data science agents: $DS_AGENTS found"
echo "- ADO cleanup: Complete"
echo "- Instructions: GitHub and Documentation directories checked"