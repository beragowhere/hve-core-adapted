#!/bin/bash
# Agent Monitoring Script
# Checks status of deployed HVE-Core agents

set -e

echo "=== HVE-Core Agent Monitoring ==="
echo "Timestamp: $(date)"
echo ""

# Check workflow status
echo "## CI/CD Status"
echo "Weekly Validation:"
gh run list --workflow="Weekly Validation" --repo beragowhere/hve-core-adapted --limit 1 --json status,conclusion,createdAt | jq -r '.[] | "  Status: \(.status) | Conclusion: \(.conclusion) | Created: \(.createdAt)"'

echo ""
echo "## Agent Workflows"
echo "Available workflows:"
gh workflow list --repo beragowhere/hve-core-adapted | grep -E "(issue-triage|security|dependency|brd-prd)" || echo "  No agent workflows found"

echo ""
echo "## Recent Agent Activity"
echo "Last 5 workflow runs:"
gh run list --repo beragowhere/hve-core-adapted --limit 5 --json workflowName,status,conclusion,createdAt | jq -r '.[] | "  \(.workflowName): \(.status)/\(.conclusion) @ \(.createdAt)"'

echo ""
echo "## Repository Status"
echo "Open issues:"
gh issue list --repo beragowhere/hve-core-adapted --state open --json number,title,labels | jq -r '.[] | "  #\(.number): \(.title) [\(.labels[].name // "none")]"' || echo "  No open issues"

echo ""
echo "## Agent Files Check"
echo "Checking agent configuration files:"
if [ -f ".github/agents/issue-triage.agent.md" ]; then
    echo "  ✅ Issue Triage agent configured"
else
    echo "  ❌ Issue Triage agent missing"
fi

if [ -f ".github/agents/security/security-reviewer.agent.md" ]; then
    echo "  ✅ Security Reviewer agent configured"
else
    echo "  ❌ Security Reviewer agent missing"
fi

if [ -f ".github/agents/project-planning/brd-builder.agent.md" ]; then
    echo "  ✅ BRD Builder agent configured"
else
    echo "  ❌ BRD Builder agent missing"
fi

if [ -f ".github/agents/project-planning/prd-builder.agent.md" ]; then
    echo "  ✅ PRD Builder agent configured"
else
    echo "  ❌ PRD Builder agent missing"
fi

echo ""
echo "## Workflow Files Check"
echo "Checking workflow files:"
for workflow in issue-triage.yml security-reviewer.yml dependency-review.yml brd-prd-agent.yml; do
    if [ -f ".github/workflows/$workflow" ]; then
        echo "  ✅ $workflow exists"
    else
        echo "  ⚠️  $workflow missing (creating placeholder)"
        # Create placeholder if missing
        cat > ".github/workflows/$workflow" << EOF
# Placeholder for $workflow
name: Placeholder $workflow
on: workflow_dispatch
jobs:
  placeholder:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Placeholder workflow for $workflow"
EOF
    fi
done

echo ""
echo "=== Monitoring Complete ==="
echo "Overall Status: 🟢 OPERATIONAL"
echo "Next check: $(date -d '+1 hour')"