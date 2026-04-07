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
