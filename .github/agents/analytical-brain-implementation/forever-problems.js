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
