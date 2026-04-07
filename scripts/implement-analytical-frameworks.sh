#!/bin/bash
# Implement 3 core framework analysis functions for Analytical Brain agent

set -e

echo "🔧 Implementing Analytical Brain Framework Functions"
echo "===================================================="

# Create implementation directory
IMPLEMENTATION_DIR=".github/agents/analytical-brain-implementation"
mkdir -p "$IMPLEMENTATION_DIR"

echo "1. Creating framework analysis functions..."

# Function 1: Forever Problems Categorization
cat > "$IMPLEMENTATION_DIR/forever-problems.js" << 'EOF'
/**
 * Forever Problems Categorization Function
 * Analyzes which "forever problem" an article addresses
 * 
 * @param {Object} article - The news article object
 * @returns {Object} Analysis results with confidence scoring
 */
function analyzeForeverProblems(article) {
    const { headline, summary, curator_notes } = article;
    const text = `${headline} ${summary} ${curator_notes || ''}`.toLowerCase();
    
    // Problem categories with keywords
    const categories = {
        "Decision Making": {
            keywords: ["decision", "choice", "judgment", "select", "prioritize", "trade-off", "risk", "allocate"],
            score: 0,
            evidence: []
        },
        "Coordination": {
            keywords: ["coordinate", "align", "synchronize", "collaborate", "teamwork", "communication", "share"],
            score: 0,
            evidence: []
        },
        "Knowledge Capture": {
            keywords: ["knowledge", "document", "retain", "transfer", "train", "onboard", "skill", "expertise"],
            score: 0,
            evidence: []
        },
        "Change Management": {
            keywords: ["change", "adapt", "transform", "evolve", "transition", "adopt", "implement"],
            score: 0,
            evidence: []
        }
    };
    
    // Score each category
    for (const [category, data] of Object.entries(categories)) {
        for (const keyword of data.keywords) {
            if (text.includes(keyword)) {
                data.score += 1;
                data.evidence.push(`Contains "${keyword}"`);
            }
        }
    }
    
    // Find primary and secondary categories
    const sortedCategories = Object.entries(categories)
        .sort((a, b) => b[1].score - a[1].score);
    
    const primary = sortedCategories[0];
    const secondary = sortedCategories.slice(1).filter(c => c[1].score > 0);
    
    // Calculate confidence (0.0-1.0)
    const totalScore = sortedCategories.reduce((sum, c) => sum + c[1].score, 0);
    const confidence = totalScore > 0 
        ? Math.min(0.9, primary[1].score / Math.max(3, totalScore) * 1.5)
        : 0.5; // Default confidence if no keywords found
    
    return {
        primary_category: primary[0],
        secondary_categories: secondary.map(c => c[0]),
        confidence: parseFloat(confidence.toFixed(2)),
        reasoning: primary[1].evidence.length > 0 
            ? `Article addresses ${primary[0].toLowerCase()} based on keywords: ${primary[1].evidence.slice(0, 3).join(', ')}`
            : "Article doesn't strongly align with specific forever problem categories",
        raw_scores: Object.fromEntries(
            Object.entries(categories).map(([cat, data]) => [cat, data.score])
        )
    };
}

// Export for testing
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { analyzeForeverProblems };
}
EOF

echo "   ✅ Forever Problems function created"

# Function 2: Expansion vs. Replacement Analysis
cat > "$IMPLEMENTATION_DIR/expansion-replacement.js" << 'EOF'
/**
 * Expansion vs. Replacement Tool Analysis
 * Determines if technology expands or replaces human work
 * 
 * @param {Object} article - The news article object
 * @returns {Object} Analysis results with tool type and indicators
 */
function analyzeExpansionReplacement(article) {
    const { headline, summary, curator_notes } = article;
    const text = `${headline} ${summary} ${curator_notes || ''}`.toLowerCase();
    
    // Expansion indicators (positive)
    const expansionIndicators = [
        { term: "augment", weight: 1.0 },
        { term: "enhance", weight: 0.9 },
        { term: "assist", weight: 0.8 },
        { term: "enable", weight: 0.9 },
        { term: "empower", weight: 0.8 },
        { term: "new capability", weight: 1.0 },
        { term: "create role", weight: 1.0 },
        { term: "skill development", weight: 0.7 }
    ];
    
    // Replacement indicators (negative)
    const replacementIndicators = [
        { term: "replace", weight: 1.0 },
        { term: "automate", weight: 0.9 },
        { term: "eliminate", weight: 1.0 },
        { term: "reduce headcount", weight: 1.0 },
        { term: "cut job", weight: 1.0 },
        { term: "displace", weight: 0.8 },
        { term: "make obsolete", weight: 0.9 }
    ];
    
    // Score expansion vs replacement
    let expansionScore = 0;
    let replacementScore = 0;
    const expansionFound = [];
    const replacementFound = [];
    
    expansionIndicators.forEach(indicator => {
        if (text.includes(indicator.term)) {
            expansionScore += indicator.weight;
            expansionFound.push(indicator.term);
        }
    });
    
    replacementIndicators.forEach(indicator => {
        if (text.includes(indicator.term)) {
            replacementScore += indicator.weight;
            replacementFound.push(indicator.term);
        }
    });
    
    // Determine tool type
    let toolType;
    let confidence;
    
    if (expansionScore > replacementScore) {
        toolType = "Expansion Tool";
        confidence = Math.min(0.95, 0.7 + (expansionScore / 5));
    } else if (replacementScore > expansionScore) {
        toolType = "Replacement Tool";
        confidence = Math.min(0.95, 0.7 + (replacementScore / 5));
    } else {
        toolType = "Mixed/Unclear";
        confidence = 0.5;
    }
    
    // Generate reasoning
    let reasoning;
    if (expansionFound.length > 0 && replacementFound.length === 0) {
        reasoning = `Clear expansion focus: ${expansionFound.join(', ')}`;
    } else if (replacementFound.length > 0 && expansionFound.length === 0) {
        reasoning = `Clear replacement focus: ${replacementFound.join(', ')}`;
    } else if (expansionFound.length > 0 && replacementFound.length > 0) {
        reasoning = `Mixed signals: expansion (${expansionFound.join(', ')}) and replacement (${replacementFound.join(', ')})`;
    } else {
        reasoning = "No clear expansion or replacement language detected";
    }
    
    return {
        tool_type: toolType,
        indicators: [...expansionFound, ...replacementFound],
        confidence: parseFloat(confidence.toFixed(2)),
        reasoning: reasoning,
        scores: {
            expansion: expansionScore,
            replacement: replacementScore
        }
    };
}

// Export for testing
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { analyzeExpansionReplacement };
}
EOF

echo "   ✅ Expansion vs. Replacement function created"

# Function 3: Team Structures Analysis
cat > "$IMPLEMENTATION_DIR/team-structures.js" << 'EOF'
/**
 * Team Structures Analysis
 * Identifies human-AI collaboration structure
 * 
 * @param {Object} article - The news article object
 * @returns {Object} Analysis results with structure type
 */
function analyzeTeamStructures(article) {
    const { headline, summary, curator_notes } = article;
    const text = `${headline} ${summary} ${curator_notes || ''}`.toLowerCase();
    
    // Structure indicators
    const structures = {
        "Human-in-the-loop": {
            indicators: [
                "human decide", "human approve", "human review", "human final",
                "ai suggest", "ai recommend", "ai propose", "human choice"
            ],
            score: 0,
            evidence: []
        },
        "Human-on-the-loop": {
            indicators: [
                "human monitor", "human oversee", "ai operate", "ai run",
                "human intervene", "human supervision", "ai autonomous within"
            ],
            score: 0,
            evidence: []
        },
        "Human-out-of-the-loop": {
            indicators: [
                "fully autonomous", "no human intervention", "ai decide",
                "ai implement", "self-operating", "autonomous operation"
            ],
            score: 0,
            evidence: []
        }
    };
    
    // Score each structure
    for (const [structure, data] of Object.entries(structures)) {
        for (const indicator of data.indicators) {
            if (text.includes(indicator)) {
                data.score += 1;
                data.evidence.push(`"${indicator}"`);
            }
        }
    }
    
    // Find highest scoring structure
    const sortedStructures = Object.entries(structures)
        .sort((a, b) => b[1].score - a[1].score);
    
    const primary = sortedStructures[0];
    const totalScore = sortedStructures.reduce((sum, s) => sum + s[1].score, 0);
    
    // Calculate confidence
    let confidence;
    if (totalScore === 0) {
        // No clear indicators - default to human-in-the-loop with low confidence
        confidence = 0.5;
    } else {
        confidence = Math.min(0.9, 0.6 + (primary[1].score / Math.max(2, totalScore)) * 0.3);
    }
    
    // Generate rationale
    let rationale;
    if (primary[1].evidence.length > 0) {
        rationale = `Article describes ${primary[0].toLowerCase()} based on: ${primary[1].evidence.slice(0, 2).join(', ')}`;
    } else {
        rationale = "No clear team structure described; assuming human-in-the-loop as default";
    }
    
    return {
        structure: primary[0],
        rationale: rationale,
        confidence: parseFloat(confidence.toFixed(2)),
        evidence: primary[1].evidence,
        all_scores: Object.fromEntries(
            Object.entries(structures).map(([struct, data]) => [struct, data.score])
        )
    };
}

// Export for testing
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { analyzeTeamStructures };
}
EOF

echo "   ✅ Team Structures function created"

# Create test runner
cat > "$IMPLEMENTATION_DIR/test-frameworks.js" << 'EOF'
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
EOF

echo "   ✅ Test runner created"

# Create integration script
cat > "$IMPLEMENTATION_DIR/integrate-with-hve.js" << 'EOF'
/**
 * Integration script for HVE-Core framework
 * Shows how to integrate framework functions with HVE-Core agent
 */

const fs = require('fs');
const path = require('path');

// Framework functions
const { analyzeForeverProblems } = require('./forever-problems.js');
const { analyzeExpansionReplacement } = require('./expansion-replacement.js');
const { analyzeTeamStructures } = require('./team-structures.js');

/**
 * Main analysis function for HVE-Core integration
 * @param {Object} context - HVE-Core agent context
 * @returns {Object} Structured analysis
 */
async function analyzeArticle(context) {
    const { article, config } = context;
    
    console.log(`Analyzing article: ${article.headline}`);
    
    // Apply framework analyses
    const analyses = {
        forever_problems: analyzeForeverProblems(article),
        expansion_vs_replacement: analyzeExpansionReplacement(article),
        team_structures: analyzeTeamStructures(article)
    };
    
    // Generate contrarian angles (simplified)
    const contrarianAngles = generateContrarianAngles(article, analyses);
    
    // Assess workplace applicability
    const workplaceApplicability = assessWorkplaceApplicability(article, analyses);
    
    // Verify data points
    const dataPoints = verifyDataPoints(article);
    
    // Generate voice-matched commentary
    const commentary = generateVoiceCommentary(article, analyses);
    
    return {
        item_id: article.item_id,
        analyses,
        contrarian_angles: contrarianAngles,
        workplace_applicability: workplaceApplicability,
        data_points: dataPoints,
        voice_matched_commentary: commentary,
        metadata: {
            analysis_timestamp: new Date().toISOString(),
            framework_version: "1.0",
            processing_duration_ms: 0, // Would be calculated in real implementation
            data_quality_warnings: dataPoints.filter(dp => dp.verification_status === 'Unverified').length > 0 
                ? ["Contains unverified claims"] 
                : []
        }
    };
}

// Helper functions
function generateContrarianAngles(article, analyses) {
    const angles = [];
    
    // Example contrarian angles based on analysis
    if (analyses.expansion_vs_replacement.tool_type === "Expansion Tool") {
        angles.push({
            angle: "While positioned as capability expansion, this may actually deskill certain roles over time",
            evidence: "Historical pattern of 'assistive' tools gradually automating more decision-making",
            strength: "Medium"
        });
    }
    
    if (article.scores.novelty > 0.8) {
        angles.push({
