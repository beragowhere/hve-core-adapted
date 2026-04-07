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
