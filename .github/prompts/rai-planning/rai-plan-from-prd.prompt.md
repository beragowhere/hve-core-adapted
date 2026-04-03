---
description: >-
  Initiate responsible AI assessment planning from PRD/BRD artifacts using the
  RAI Planner agent in from-prd mode
agent: "RAI Planner"
---

# RAI Plan from PRD/BRD

Activate the RAI Planner in **from-prd mode** to plan for AI-specific risk assessment for project slug `${input:project-slug}`.

> **Disclaimer** — This tool provides structured prompts and frameworks to support responsible AI planning. It is not a substitute for professional legal, compliance, or ethics review. All outputs are suggestions for human evaluation. Organizational RAI policies and applicable regulations take precedence.

> **Attribution** — This assessment references the [Microsoft Responsible AI Impact Assessment Guide](https://aka.ms/RAI) (© 2022 Microsoft Corporation, all rights reserved). The Guide is provided "as-is" and does not provide any legal rights to any intellectual property in any Microsoft product. You may copy and use this document for your internal, reference purposes. This assessment also references NIST AI RMF 1.0, a U.S. Government work not subject to copyright protection in the United States.

## Requirements

### PRD/BRD Discovery

Scan for product and business requirements documents:

**Primary paths:**

- `.copilot-tracking/prd-sessions/` for PRD artifacts
- `.copilot-tracking/brd-sessions/` for BRD artifacts

**Secondary scan:**

Search the workspace for files matching `*prd*`, `*brd*`, `*product-requirements*`, or `*business-requirements*` patterns.

Present discovered artifacts:

- ✅ Found artifacts with file paths and brief descriptions
- ❌ Missing artifact locations

If zero artifacts are found, fall back to capture mode and explain the switch.

### AI System Scope Extraction

Extract from the discovered artifacts:

1. Project name and AI system purpose
2. AI components and model types
3. Technology stack and deployment targets
4. Data classification and data flow
5. Stakeholder roles (developers, operators, affected individuals)
6. Intended use scenarios and user populations

### State Initialization

Create the project directory at `.copilot-tracking/rai-plans/${input:project-slug}/`.

Initialize `state.json` with:

- `entryMode` set to `"from-prd"`
- `currentPhase` set to `1`
- Pre-populated fields from the extracted scope

### Phase 1 Entry

Present the extracted AI system scope as a checklist with markers:

- ✅ Items confirmed from PRD/BRD
- ❓ Items that need clarification or are missing

Ask 3 to 5 clarifying questions that target AI-specific gaps not covered by the requirements documents, such as model selection rationale, training data provenance, fairness considerations, and unintended use scenarios.

Also ask whether the user has evaluation standards, sensitive use categories, or output format requirements to supply for storage in `.copilot-tracking/rai-plans/references/`.
