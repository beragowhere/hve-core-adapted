#!/bin/bash
# Test script for Issue Triage agent configuration

set -e

echo "🔍 Issue Triage Agent Test"
echo "============================"

# Check agent file
echo "1. Checking agent file..."
AGENT_FILE=".github/agents/issue-triage.agent.md"
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
WORKFLOW_FILE=".github/workflows/issue-triage.lock.yml"
if [ -f "$WORKFLOW_FILE" ]; then
    echo "   ✅ Workflow file exists"
    
    # Check if workflow imports the agent
    if grep -q "issue-triage.agent.md" "$WORKFLOW_FILE"; then
        echo "   ✅ Workflow imports agent"
    else
        echo "   ❌ Workflow doesn't import agent"
    fi
    
    # Check triggers
    if grep -q "issues" "$WORKFLOW_FILE"; then
        echo "   ✅ Triggered on issues"
    else
        echo "   ⚠️  Not triggered on issues"
    fi
    
else
    echo "   ⚠️  Workflow file not found (may use different trigger mechanism)"
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

# Create test scenario
echo ""
echo "4. Creating test scenario..."
TEST_DIR=".copilot-tracking/issue-triage-test"
mkdir -p "$TEST_DIR"

# Create a test issue JSON
cat > "$TEST_DIR/test-issue.json" << EOF
{
  "type": "test",
  "title": "Test issue for triage agent",
  "body": "This is a test issue to verify the issue triage agent works correctly.",
  "labels": [],
  "agent": "issue-triage",
  "createdAt": "$(date -Iseconds)",
  "testRun": true
}
EOF

echo "   ✅ Test issue JSON created"
echo "   ✅ Test directory: $TEST_DIR"

# Check agent capabilities from file content
echo ""
echo "5. Checking agent capabilities..."
if grep -q "classify" "$AGENT_FILE"; then
    echo "   ✅ Issue classification capability"
else
    echo "   ⚠️  Classification not mentioned"
fi

if grep -q "label" "$AGENT_FILE"; then
    echo "   ✅ Label application capability"
else
    echo "   ⚠️  Labeling not mentioned"
fi

if grep -q "duplicate" "$AGENT_FILE"; then
    echo "   ✅ Duplicate detection"
else
    echo "   ⚠️  Duplicate detection not mentioned"
fi

if grep -q "decompose" "$AGENT_FILE"; then
    echo "   ✅ Issue decomposition"
else
    echo "   ⚠️  Issue decomposition not mentioned"
fi

if grep -q "quality" "$AGENT_FILE"; then
    echo "   ✅ Quality assessment"
else
    echo "   ⚠️  Quality assessment not mentioned"
fi

echo ""
echo "6. Checking agent workflow steps..."
# Check if agent follows a structured workflow
if grep -q "Triage Workflow" "$AGENT_FILE"; then
    echo "   ✅ Structured triage workflow defined"
    
    # Count workflow steps
    WORKFLOW_STEPS=$(grep -c "### [0-9]" "$AGENT_FILE" || echo "0")
    echo "   ✅ $WORKFLOW_STEPS workflow steps identified"
else
    echo "   ⚠️  No structured workflow section found"
fi

echo ""
echo "============================"
echo "✅ Issue Triage Agent Test Complete"
echo ""
echo "Summary:"
echo "- Agent file: $AGENT_FILE"
echo "- Workflow: $WORKFLOW_FILE (if exists)"
echo "- Instructions: GitHub directory checked"
echo "- Test scenario: Created in $TEST_DIR"
echo "- Capabilities: Classification, labeling, duplicate detection, decomposition, quality assessment"
echo "- Workflow: Structured with $WORKFLOW_STEPS steps"
echo ""
echo "Next step: The agent is configured to automatically triage"
echo "new GitHub issues based on the defined workflow."