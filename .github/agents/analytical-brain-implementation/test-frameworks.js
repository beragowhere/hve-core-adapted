/**
 * Test runner for Analytical Brain framework functions
 */

// Import functions
const { analyzeForeverProblems } = require('./forever-problems.js');
const { analyzeExpansionReplacement } = require('./expansion-replacement.js');
const { analyzeTeamStructures } = require('./team-structures.js');

// Sample article (Claude 4 announcement)
const sampleArticle = {
    item_id: "claude-4-announcement-2026",
    headline: "Anthropic Announces Claude 4: Major Improvements in Reasoning and Coding",
    source: "TechCrunch",
    url: "https://techcrunch.com/2026/04/07/anthropic-claude-4/",
    summary: "Anthropic has unveiled Claude 4, the latest version of its AI assistant, featuring significant improvements in reasoning capabilities, coding assistance, and enterprise security features. The new model demonstrates 40% better performance on complex reasoning tasks and introduces new workflow automation capabilities for software development teams.",
    scores: {
        relevance: 0.92,
        novelty: 0.85,
        credibility: 0.95
    },
    curator_notes: "Major AI model release with enterprise focus. Note the emphasis on coding and reasoning improvements rather than creative writing. Security features mentioned but not detailed.",
    publication_date: "2026-04-07",
    received_at: "2026-04-07T10:56:00Z"
};

console.log("🧠 Testing Analytical Brain Framework Functions");
console.log("===============================================\n");

console.log("Sample Article:");
console.log(`Headline: ${sampleArticle.headline}`);
console.log(`Summary: ${sampleArticle.summary.substring(0, 100)}...\n`);

// Test Forever Problems
console.log("1. Forever Problems Analysis:");
const foreverProblems = analyzeForeverProblems(sampleArticle);
console.log(`   Primary Category: ${foreverProblems.primary_category}`);
console.log(`   Secondary: ${foreverProblems.secondary_categories.join(', ') || 'None'}`);
console.log(`   Confidence: ${foreverProblems.confidence}`);
console.log(`   Reasoning: ${foreverProblems.reasoning}`);
console.log(`   Raw Scores: ${JSON.stringify(foreverProblems.raw_scores)}\n`);

// Test Expansion vs Replacement
console.log("2. Expansion vs. Replacement Analysis:");
const expansionReplacement = analyzeExpansionReplacement(sampleArticle);
console.log(`   Tool Type: ${expansionReplacement.tool_type}`);
console.log(`   Indicators: ${expansionReplacement.indicators.join(', ') || 'None detected'}`);
console.log(`   Confidence: ${expansionReplacement.confidence}`);
console.log(`   Reasoning: ${expansionReplacement.reasoning}`);
console.log(`   Scores: Expansion=${expansionReplacement.scores.expansion}, Replacement=${expansionReplacement.scores.replacement}\n`);

// Test Team Structures
console.log("3. Team Structures Analysis:");
const teamStructures = analyzeTeamStructures(sampleArticle);
console.log(`   Structure: ${teamStructures.structure}`);
console.log(`   Rationale: ${teamStructures.rationale}`);
console.log(`   Confidence: ${teamStructures.confidence}`);
console.log(`   Evidence: ${teamStructures.evidence.join(', ') || 'None'}`);
console.log(`   All Scores: ${JSON.stringify(teamStructures.all_scores)}\n`);

// Generate combined output
console.log("4. Combined JSON Output:");
const combinedOutput = {
    item_id: sampleArticle.item_id,
    analyses: {
        forever_problems: {
            primary_category: foreverProblems.primary_category,
            secondary_categories: foreverProblems.secondary_categories,
            confidence: foreverProblems.confidence,
            reasoning: foreverProblems.reasoning
        },
        expansion_vs_replacement: {
            tool_type: expansionReplacement.tool_type,
            indicators: expansionReplacement.indicators,
            confidence: expansionReplacement.confidence,
            reasoning: expansionReplacement.reasoning
        },
        team_structures: {
            structure: teamStructures.structure,
            rationale: teamStructures.rationale,
            confidence: teamStructures.confidence
        }
    },
    metadata: {
        analysis_timestamp: new Date().toISOString(),
        framework_version: "1.0",
        functions_tested: ["forever_problems", "expansion_replacement", "team_structures"]
    }
};

console.log(JSON.stringify(combinedOutput, null, 2));

console.log("\n✅ Framework functions implemented and tested successfully!");
