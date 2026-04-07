// Simple test of framework functions
const fs = require('fs');

// Load the functions
const foreverProblemsCode = fs.readFileSync('./forever-problems.js', 'utf8');
const expansionCode = fs.readFileSync('./expansion-replacement.js', 'utf8');
const teamCode = fs.readFileSync('./team-structures.js', 'utf8');

// Evaluate the code to get functions
eval(foreverProblemsCode);
eval(expansionCode);
eval(teamCode);

// Sample article
const sampleArticle = {
    item_id: "claude-4-announcement-2026",
    headline: "Anthropic Announces Claude 4: Major Improvements in Reasoning and Coding",
    source: "TechCrunch",
    summary: "Anthropic has unveiled Claude 4, the latest version of its AI assistant, featuring significant improvements in reasoning capabilities, coding assistance, and enterprise security features. The new model demonstrates 40% better performance on complex reasoning tasks and introduces new workflow automation capabilities for software development teams.",
    curator_notes: "Major AI model release with enterprise focus. Note the emphasis on coding and reasoning improvements rather than creative writing.",
    scores: {
        relevance: 0.92,
        novelty: 0.85,
        credibility: 0.95
    }
};

console.log("🧠 Testing Analytical Brain Framework Functions");
console.log("===============================================\n");

// Test each function
try {
    console.log("1. Forever Problems Analysis:");
    const fpResult = analyzeForeverProblems(sampleArticle);
    console.log(JSON.stringify(fpResult, null, 2));
    
    console.log("\n2. Expansion vs. Replacement Analysis:");
    const erResult = analyzeExpansionReplacement(sampleArticle);
    console.log(JSON.stringify(erResult, null, 2));
    
    console.log("\n3. Team Structures Analysis:");
    const tsResult = analyzeTeamStructures(sampleArticle);
    console.log(JSON.stringify(tsResult, null, 2));
    
    console.log("\n✅ All functions executed successfully!");
    
    // Create combined output
    const combined = {
        item_id: sampleArticle.item_id,
        analyses: {
            forever_problems: {
                primary_category: fpResult.primary_category,
                secondary_categories: fpResult.secondary_categories,
                confidence: fpResult.confidence,
                reasoning: fpResult.reasoning
            },
            expansion_vs_replacement: {
                tool_type: erResult.tool_type,
                indicators: erResult.indicators,
                confidence: erResult.confidence,
                reasoning: erResult.reasoning
            },
            team_structures: {
                structure: tsResult.structure,
                rationale: tsResult.rationale,
                confidence: tsResult.confidence
            }
        },
        metadata: {
            analysis_timestamp: new Date().toISOString(),
            framework_version: "1.0",
            status: "IMPLEMENTATION_COMPLETE"
        }
    };
    
    console.log("\n📊 Combined Output:");
    console.log(JSON.stringify(combined, null, 2));
    
} catch (error) {
    console.error("❌ Error testing functions:", error.message);
    console.error(error.stack);
}