#!/usr/bin/env node
/**
 * OpenClaw Issue Labeler
 * 
 * Monitors GitHub issues and applies appropriate labels based on title/content.
 * Runs as a cron job or manual trigger via OpenClaw.
 */

const { execSync } = require('child_process');
const fs = require('fs');

// Configuration
const REPO = 'beragowhere/hve-core-adapted';
const LABEL_MAPPINGS = {
  bug: ['bug', 'fix', 'error', 'broken', 'crash', 'fail'],
  documentation: ['doc', 'readme', 'documentation', 'guide', 'tutorial'],
  security: ['security', 'vulnerability', 'cve', 'exploit', 'attack'],
  feature: ['feature', 'new', 'add', 'enhance', 'improve'],
  maintenance: ['chore', 'maintenance', 'cleanup', 'refactor', 'update'],
  enhancement: [] // default
};

function classifyIssue(title, body = '') {
  const text = (title + ' ' + body).toLowerCase();
  
  for (const [label, keywords] of Object.entries(LABEL_MAPPINGS)) {
    for (const keyword of keywords) {
      if (text.includes(keyword)) {
        return label;
      }
    }
  }
  
  return 'enhancement'; // default
}

function getOpenIssues() {
  try {
    const cmd = `gh issue list --repo ${REPO} --state open --json number,title,body,labels --limit 20`;
    const output = execSync(cmd, { encoding: 'utf8' });
    return JSON.parse(output);
  } catch (error) {
    console.error('Error fetching issues:', error.message);
    return [];
  }
}

function labelIssue(issueNumber, label) {
  try {
    // Check if label already exists
    const checkCmd = `gh issue view ${issueNumber} --repo ${REPO} --json labels`;
    const checkOutput = execSync(checkCmd, { encoding: 'utf8' });
    const issueData = JSON.parse(checkOutput);
    
    const existingLabels = issueData.labels.map(l => l.name);
    if (existingLabels.includes(label)) {
      console.log(`Issue #${issueNumber} already has label: ${label}`);
      return false;
    }
    
    // Add the label
    const cmd = `gh issue edit ${issueNumber} --repo ${REPO} --add-label "${label}"`;
    execSync(cmd, { encoding: 'utf8' });
    console.log(`✅ Labeled issue #${issueNumber} as: ${label}`);
    
    // Add comment for enhancements
    if (label === 'enhancement') {
      const commentCmd = `gh issue comment ${issueNumber} --repo ${REPO} --body "🔍 **Issue Labeled**\\n\\nI've labeled this issue as an **enhancement**.\\n\\nPlease provide more details about the specific change you're proposing if you haven't already included them in the issue description."`;
      execSync(commentCmd, { encoding: 'utf8' });
    }
    
    return true;
  } catch (error) {
    console.error(`Error labeling issue #${issueNumber}:`, error.message);
    return false;
  }
}

function processIssues() {
  console.log(`🚀 Processing issues for ${REPO}`);
  console.log('=' .repeat(50));
  
  const issues = getOpenIssues();
  console.log(`Found ${issues.length} open issues`);
  
  let processed = 0;
  let labeled = 0;
  
  for (const issue of issues) {
    console.log(`\n📝 Issue #${issue.number}: ${issue.title}`);
    
    // Skip if already has a type label
    const existingLabels = issue.labels.map(l => l.name);
    const hasTypeLabel = Object.keys(LABEL_MAPPINGS).some(label => 
      existingLabels.includes(label)
    );
    
    if (hasTypeLabel) {
      console.log(`  ⏩ Already has type label: ${existingLabels.join(', ')}`);
      continue;
    }
    
    // Classify and label
    const label = classifyIssue(issue.title, issue.body || '');
    console.log(`  🏷️  Classified as: ${label}`);
    
    if (labelIssue(issue.number, label)) {
      labeled++;
    }
    
    processed++;
  }
  
  console.log('\n' + '=' .repeat(50));
  console.log(`📊 Summary:`);
  console.log(`  Processed: ${processed} issues`);
  console.log(`  Labeled: ${labeled} issues`);
  console.log(`  Skipped: ${issues.length - processed} issues (already labeled)`);
  
  return { processed, labeled, total: issues.length };
}

// Main execution
if (require.main === module) {
  // Check if gh CLI is authenticated
  try {
    execSync('gh auth status', { stdio: 'ignore' });
  } catch (error) {
    console.error('❌ GitHub CLI not authenticated. Please run: gh auth login');
    process.exit(1);
  }
  
  const result = processIssues();
  
  // Log to file for monitoring
  const logEntry = {
    timestamp: new Date().toISOString(),
    repo: REPO,
    ...result
  };
  
  const logFile = '/tmp/openclaw-issue-labeler.log';
  fs.appendFileSync(logFile, JSON.stringify(logEntry) + '\n');
  
  console.log(`\n📝 Log written to: ${logFile}`);
}

module.exports = { classifyIssue, processIssues };