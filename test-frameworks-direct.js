// Direct test of framework functions
console.log("🧠 Testing Analytical Brain Framework Functions");

// Simple implementation of first function for testing
function analyzeForeverProblems(article) {
    const text = (article.headline + " " + article.summary).toLowerCase();
    
    const categories = {
        "Decision Making": { keywords: ["decision", "choice", "judgment"], score: 0 },
        "Coordination": { keywords: ["coordinate", "align", "team"], score: 0 },
        "Knowledge Capture": { keywords: ["knowledge", "document", "train"], score: 0 },
        "Change Management": { keywords: ["change", "adapt", "implement"], score: 0 }
    };
    
    for (const [category, data] of Object.entries(categories)) {
        for (const keyword of data.keywords) {
            if (text.includes(keyword)) data.score++;
        }
    }
    
    const sorted = Object.entries(categories).sort((a, b) => b[1].score - a[1].score);
    const primary = sorted[0];
    
    return {
        primary_category: primary[0],
        secondary_categories: sorted.slice(1).filter(c => c[1].score > 0).map(c => c[0]),
        confidence: 0.85,
        reasoning: `Analyzed text for forever problem categories`
    };
}

// Sample article
const article = {
    headline: "AI Assistant Improves Coding Productivity",
    summary: "New AI tool helps developers write better code and document their work more effectively."
};

const result = analyzeForeverProblems(article);
console.log("Result:", JSON.stringify(result, null, 2));
console.log("\n✅ Framework function test complete!");