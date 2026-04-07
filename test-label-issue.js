// Simple test to classify an issue
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

// Test cases
const testCases = [
  { title: 'Bug: Test auto labeling', expected: 'bug' },
  { title: 'Documentation: Update README', expected: 'documentation' },
  { title: 'Security: Check vulnerability', expected: 'security' },
  { title: 'Feature: Add new agent type', expected: 'feature' },
  { title: 'Maintenance: Clean up old files', expected: 'maintenance' },
  { title: 'Improve performance', expected: 'enhancement' },
  { title: 'Fix crash when loading large files', expected: 'bug' },
  { title: 'Add documentation for API', expected: 'documentation' }
];

console.log('Testing issue classification:');
console.log('='.repeat(40));

let passed = 0;
for (const test of testCases) {
  const result = classifyIssue(test.title);
  const status = result === test.expected ? '✅' : '❌';
  console.log(`${status} "${test.title}" -> ${result} (expected: ${test.expected})`);
  if (result === test.expected) passed++;
}

console.log('='.repeat(40));
console.log(`Results: ${passed}/${testCases.length} tests passed`);

// Also test actual GitHub issue classification
console.log('\nActual issues in repository:');
const { execSync } = require('child_process');
try {
  const output = execSync('gh issue list --repo beragowhere/hve-core-adapted --state open --json number,title --limit 5', { encoding: 'utf8' });
  const issues = JSON.parse(output);
  console.log(`Found ${issues.length} open issues:`);
  issues.forEach(issue => {
    const label = classifyIssue(issue.title);
    console.log(`  #${issue.number}: "${issue.title}" -> ${label}`);
  });
} catch (error) {
  console.log('Note: GitHub CLI not available in this test environment');
}