# Analytical Frameworks Instructions

## Purpose
Guide the Analytical Brain agent in applying Stephen's 10 analytical frameworks to curated news items. These frameworks transform raw news into structured, insightful analysis.

## Framework 1: Forever Problems Categories

### Definition
Categorize which "forever problem" the article addresses. Forever problems are fundamental organizational challenges that persist despite technological change.

### Categories
1. **Decision Making**
   - Choices, judgments, selections under uncertainty
   - Resource allocation, prioritization, trade-offs
   - Risk assessment, opportunity evaluation

2. **Coordination**
   - Alignment across teams, departments, organizations
   - Synchronization of activities, timelines, goals
   - Collaboration, communication, information sharing

3. **Knowledge Capture**
   - Documentation, retention, transfer of expertise
   - Training, onboarding, skill development
   - Institutional memory, best practices

4. **Change Management**
   - Adaptation to new technologies, processes, markets
   - Transformation of culture, structure, capabilities
   - Evolution of strategies, business models

### Analysis Method
1. Read the article summary and curator notes
2. Identify which problem domain is primarily addressed
3. Score confidence for each category (0.0-1.0)
4. Select primary category (highest confidence)
5. Select secondary categories (confidence > 0.6)
6. Provide reasoning with specific article evidence

### Output Format
```json
{
  "forever_problems": {
    "primary_category": "Decision Making",
    "secondary_categories": ["Coordination", "Knowledge Capture"],
    "confidence": 0.88,
    "reasoning": "The article focuses on AI-assisted decision support systems for resource allocation under uncertainty, with secondary implications for team coordination and knowledge retention."
  }
}
```

## Framework 2: Expansion vs. Replacement Tool Indicators

### Definition
Determine whether the technology described expands human capabilities or replaces human work.

### Indicators

**Expansion Tool (Augments Human Capability)**
- Creates new roles, tasks, or capabilities
- Enables work that was previously impossible
- Requires new skills or training
- Increases human effectiveness, not efficiency alone
- Language: "augments," "assists," "enhances," "enables"

**Replacement Tool (Automates Human Work)**
- Eliminates positions or reduces headcount
- Automates existing tasks completely
- Reduces need for human intervention
- Focuses on cost reduction, not capability expansion
- Language: "automates," "replaces," "eliminates," "reduces"

### Analysis Method
1. Analyze language around human impact
2. Examine described changes to workforce
3. Assess whether new skills are required or old ones made obsolete
4. Determine primary tool type with confidence score
5. List specific indicators found in the article

### Output Format
```json
{
  "expansion_vs_replacement": {
    "tool_type": "Expansion Tool",
    "indicators": [
      "augments human analytical capability",
      "creates new workflow possibilities",
      "requires data interpretation skills"
    ],
    "confidence": 0.92,
    "reasoning": "The technology enables new types of data analysis previously requiring specialized expertise, expanding what teams can accomplish rather than replacing existing analysts."
  }
}
```

## Framework 3: Team Structures

### Definition
Identify the human-AI collaboration structure described in the article.

### Structures

**Human-in-the-loop**
- AI provides recommendations, suggestions, or options
- Human makes final decisions, approvals, or selections
- Human has veto power, override capability
- AI assists but doesn't act autonomously
- Example: AI suggests marketing copy, human approves

**Human-on-the-loop**
- AI operates autonomously within defined parameters
- Human monitors performance, intervenes if needed
- Human sets boundaries, rules, constraints
- AI acts, human oversees
- Example: AI manages inventory, human monitors stock levels

**Human-out-of-the-loop**
- Fully autonomous operation
- Human sets initial parameters, doesn't intervene routinely
- AI makes decisions and implements them
- Human may review outcomes periodically
- Example: Algorithmic trading systems

### Analysis Method
1. Identify decision flow described
2. Determine approval mechanisms and oversight
3. Assess autonomy level of AI system
4. Identify human intervention points
5. Determine structure with confidence score

### Output Format
```json
{
  "team_structures": {
    "structure": "Human-on-the-loop",
    "rationale": "The system operates autonomously to optimize workflows but requires human monitoring for quality assurance and exception handling.",
    "confidence": 0.85
  }
}
```

## Framework 4: AI-Friendly vs. Human-Retained Steps (Pending)

### Definition
Distinguish which workflow steps are suitable for AI automation vs. which should remain human-controlled.

### Analysis Method
1. Deconstruct described workflows into discrete steps
2. Categorize each step as AI-friendly or human-retained
3. Identify transition points between AI and human work
4. Assess automation boundaries and handoff requirements

## Framework 5: Killer App vs. Portfolio Effect Reality (Pending)

### Definition
Evaluate whether adoption follows a "killer app" pattern (single dominant use case) or "portfolio effect" (multiple complementary use cases).

## Framework 6: Bottlenecks (Pending)

### Definition
Identify organizational and technical constraints that limit adoption or effectiveness.

## Framework 7: SME Advantage Analysis (Pending)

### Definition
Evaluate how the technology affects subject matter experts (SMEs) - whether it threatens, enhances, or transforms their role.

## Framework 8: Sameness Problem (Pending)

### Definition
Identify market convergence, differentiation issues, and competitive homogeneity.

## Framework 9: Intensification Problem (Pending)

### Definition
Identify workload increases, expectation escalation, and productivity pressure.

## Framework 10: Principled Refusal (Pending)

### Definition
Identify appropriate rejection points and decision boundaries.

## General Analysis Principles

### 1. Evidence-Based
- Ground all analysis in specific article content
- Quote or reference specific claims when possible
- Avoid speculation beyond what's stated

### 2. Confidence Scoring
- 0.9-1.0: Strong evidence, clear categorization
- 0.7-0.89: Good evidence, reasonable inference
- 0.5-0.69: Some evidence, requires interpretation
- <0.5: Weak evidence, speculative

### 3. Contrarian Mindset
- Challenge consensus or hype
- Look for what's NOT said
- Consider alternative interpretations
- Question unverified claims

### 4. Workplace Focus
- Always consider practical applicability
- Assess implementation challenges
- Evaluate organizational impact
- Consider change management requirements

## Quality Checks

### Input Validation
1. Verify required fields present (headline, summary, scores)
2. Check URL accessibility (if verification needed)
3. Validate score ranges (0.0-1.0)
4. Ensure curator notes provide context

### Analysis Validation
1. Check confidence scores align with evidence strength
2. Verify reasoning references specific article content
3. Ensure frameworks are applied consistently
4. Validate output schema compliance

### Output Validation
1. Verify JSON structure matches schema
2. Check for missing or null values
3. Validate confidence score ranges
4. Ensure metadata includes processing details