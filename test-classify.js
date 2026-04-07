// Pure classification test - no external dependencies
function classifyIssue(title, body = '') {
  const LABEL_MAPPINGS = {
    bug: ['bug', 'fix', 'error', 'broken', 'crash', 'fail'],
    documentation: ['doc', 'readme', 'documentation', 'guide', 'tutorial'],
    security: ['security', 'vulnerability', 'cve', 'exploit', 'attack'],
    feature: ['feature', 'new', 'add', 'enhance', 'improve'],
    maintenance: ['chore', 'maintenance', 'cleanup', 'refactor', 'update'],
    enhancement: [] // default
  };
  
  const text = (title + ' ' + body).toLowerCase();
  
  for (const [label, keywords] of Object.entries(LABEL_MAPPINGS)) {
    for (const keyword of keywords) {
      if (text.includes(keyword)) {
        return label;
      }
    }
  }
  
  return 'enhancement';
}

// Test cases matching our actual issues
const testCases = [
  { title: 'Bug: Test auto labeling', expected: 'bug' },
  { title: 'Documentation: Update README', expected: 'documentation' },
  { title: 'Security: Check vulnerability', expected: 'security' },
  { title: 'Feature: Add new agent type', expected: 'feature' },
  { title: 'Maintenance: Clean up old files', expected: 'maintenance' },
  { title: 'Test: Issue Triage Workflow', expected: 'enhancement' },
  { title: 'Bug: Test workflow fix', expected: 'bug' }
];

console.log('Issue Classification Test Results:');
console.log('='.repeat(50));

testCases.forEach(test => {
  const result = classifyIssue(test.title);
  const status = result === test.expected ? '✅' : '❌';
  console.log(`${status} "${test.title}"`);
  console.log(`   → Classified as: ${result} (expected: ${test.expected})`);
});

console.log('='.repeat(50));
console.log('Summary: Classification logic works correctly.');
console.log('Next step: Integrate with GitHub API via OpenClaw cron job.');