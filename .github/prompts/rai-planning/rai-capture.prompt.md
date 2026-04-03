---
description: >-
  Initiate responsible AI assessment planning from existing knowledge using the
  RAI Planner agent in capture mode
agent: "RAI Planner"
---

# RAI Capture

Activate the RAI Planner in **capture mode** for project slug `${input:project-slug}`.

> **Disclaimer** — This tool provides structured prompts and frameworks to support responsible AI planning. It is not a substitute for professional legal, compliance, or ethics review. All outputs are suggestions for human evaluation. Organizational RAI policies and applicable regulations take precedence.

> **Attribution** — This assessment references the [Microsoft Responsible AI Impact Assessment Guide](https://aka.ms/RAI) (© 2022 Microsoft Corporation, all rights reserved). The Guide is provided "as-is" and does not provide any legal rights to any intellectual property in any Microsoft product. You may copy and use this document for your internal, reference purposes. This assessment also references NIST AI RMF 1.0, a U.S. Government work not subject to copyright protection in the United States.

## Requirements

Initialize capture mode at `.copilot-tracking/rai-plans/${input:project-slug}/`.

Write `state.json` with `entryMode` set to `"capture"`, `currentPhase` set to `1`, and all other fields at their default empty values.

If the user has provided existing AI system notes, model descriptions, or risk context, extract relevant details and pre-populate the system definition where possible.

Begin the Phase 1 AI System Scoping interview with up to 7 focused questions covering:

- AI system purpose and intended outcomes
- AI components and model types (ML models, LLMs, vision, speech)
- Technology stack and deployment context
- Data inputs, outputs, and data flow
- Stakeholder roles (developers, operators, affected individuals)
- Intended and unintended use scenarios
- Known AI-specific risks or concerns
- User-supplied evaluation standards, sensitive use categories, or output format requirements to store in `.copilot-tracking/rai-plans/references/`

Present a short summary sentence of the assessment scope before asking questions.
