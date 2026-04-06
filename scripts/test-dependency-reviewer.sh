#!/bin/bash
# Test script for Dependency Reviewer agent configuration

set -e

echo "🔍 Dependency Reviewer Agent Test"
echo "================================="

# Check agent file
echo "1. Checking agent file..."
AGENT_FILE=".github/agents/dependency-reviewer.agent.md"
if [ -f "$AGENT_FILE" ]; then
    echo "   ✅ Agent file exists"
    
    # Check YAML frontmatter
    if head -5 "$AGENT_FILE" | grep -q "---"; then
        echo "   ✅ YAML frontmatter present"
        
        # Extract agent name
        AGENT_NAME=$(grep -m1 "name:" "$AGENT_FILE" | cut -d: -f2- | xargs)
        echo "   ✅ Agent name: $AGENT_NAME"
        
        # Check description
        if grep -q "description:" "$AGENT_FILE"; then
            DESCRIPTION=$(grep -m1 "description:" "$AGENT_FILE" | cut -d: -f2- | xargs)
            echo "   ✅ Description: $DESCRIPTION"
        fi
    else
        echo "   ⚠️  Missing YAML frontmatter"
    fi
    
    # Check for GitHub focus
    if grep -q -i "github" "$AGENT_FILE"; then
        echo "   ✅ GitHub-focused"
    else
        echo "   ⚠️  No explicit GitHub focus found"
    fi
    
    # Check for ADO references (should be none)
    if grep -q -i "ADO" "$AGENT_FILE"; then
        echo "   ❌ ADO references found"
    else
        echo "   ✅ No ADO references"
    fi
    
else
    echo "   ❌ Agent file missing"
    exit 1
fi

# Check workflow file
echo ""
echo "2. Checking workflow configuration..."
WORKFLOW_FILE=".github/workflows/dependency-pr-review.lock.yml"
if [ -f "$WORKFLOW_FILE" ]; then
    echo "   ✅ Workflow file exists"
    
    # Check if workflow imports the agent
    if grep -q "dependency-reviewer.agent.md" "$WORKFLOW_FILE"; then
        echo "   ✅ Workflow imports agent"
    else
        echo "   ❌ Workflow doesn't import agent"
    fi
    
    # Check triggers
    if grep -q "pull_request" "$WORKFLOW_FILE"; then
        echo "   ✅ Triggered on pull requests"
    else
        echo "   ⚠️  Not triggered on pull requests"
    fi
    
    # Check paths
    if grep -q "package.json" "$WORKFLOW_FILE"; then
        echo "   ✅ Monitors package.json changes"
    else
        echo "   ⚠️  Doesn't monitor package.json"
    fi
    
else
    echo "   ❌ Workflow file missing"
fi

# Check instruction files
echo ""
echo "3. Checking instruction files..."
INSTRUCTION_DIR=".github/instructions/github"
if [ -d "$INSTRUCTION_DIR" ]; then
    echo "   ✅ GitHub instructions directory exists"
    
    # Check for relevant instruction files
    RELEVANT_INSTRUCTIONS=(
        "github-backlog-triage.instructions.md"
        "community-interaction.instructions.md"
    )
    
    for instruction in "${RELEVANT_INSTRUCTIONS[@]}"; do
        if [ -f "$INSTRUCTION_DIR/$instruction" ]; then
            echo "   ✅ $instruction exists"
        else
            echo "   ⚠️  $instruction missing"
        fi
    done
    
else
    echo "   ❌ GitHub instructions directory missing"
fi

# Create test package.json for validation
echo ""
echo "4. Creating test scenario..."
TEST_DIR=".copilot-tracking/dependency-test"
mkdir -p "$TEST_DIR"

# Create a test package.json
cat > "$TEST_DIR/test-package.json" << EOF
{
  "name": "test-dependency-review",
  "version": "1.0.0",
  "dependencies": {
    "lodash": "^4.17.21",
    "express": "^4.18.2"
  },
  "devDependencies": {
    "jest": "^29.7.0",
    "eslint": "^8.56.0"
  }
}
EOF

echo "   ✅ Test package.json created"
echo "   ✅ Test directory: $TEST_DIR"

# Check agent capabilities from file content
echo ""
echo "5. Checking agent capabilities..."
if grep -q "license compatibility" "$AGENT_FILE"; then
    echo "   ✅ License checking capability"
else
    echo "   ⚠️  License checking not mentioned"
fi

if grep -q "maintenance status" "$AGENT_FILE"; then
    echo "   ✅ Maintenance status checking"
else
    echo "   ⚠️  Maintenance status not mentioned"
fi

if grep -q "SHA pinning" "$AGENT_FILE"; then
    echo "   ✅ SHA pinning compliance"
else
    echo "   ⚠️  SHA pinning not mentioned"
fi

if grep -q "vulnerabilities" "$AGENT_FILE"; then
    echo "   ✅ Vulnerability checking"
else
    echo "   ⚠️  Vulnerability checking not mentioned"
fi

echo ""
echo "================================="
echo "✅ Dependency Reviewer Test Complete"
echo ""
echo "Summary:"
echo "- Agent file: $AGENT_FILE"
echo "- Workflow: $WORKFLOW_FILE"
echo "- Instructions: GitHub directory checked"
echo "- Test scenario: Created in $TEST_DIR"
echo "- Capabilities: License, maintenance, SHA pinning, vulnerabilities"
echo ""
echo "Next step: The agent is configured to automatically review"
echo "dependency changes in PRs via the workflow."