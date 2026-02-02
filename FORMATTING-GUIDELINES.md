# Formatting Guidelines for Specification Documents

This file provides guidance for creating specification documents following Microsoft's internal documentation standards.

## Document Writing Style Guide

This directory contains specification documents, approach notes, and planning documents for Microsoft product features. When creating new documents or formatting existing ones, follow the writing style patterns below.

## Document Structure

All specification documents should follow this hierarchical structure:

### Required Sections (in order)
1. **Title** - Clear, descriptive feature or initiative name
2. **Introduction/Overview** - Brief context and purpose (2-3 paragraphs max)
3. **Problem Details/User Asks** - Evidence-based problem statement
4. **Solution Approach** - Proposed solution with clear reasoning
5. **Detailed Requirements** - Specific, actionable requirements
6. **Evaluation Set** - Test scenarios and success criteria
7. **Project Plan** - Timeline with DRIs and dependencies
8. **Open Questions** - Explicit list of unresolved items
9. **References** - Links to related documents
10. **Appendix** - Technical deep-dives and supplementary information

### Optional Sections (include when relevant)
- **Glossary** - Define acronyms upfront if document uses many (e.g., "CAs - Classic Attachments")
- **Compete Analysis** - What competitors are doing (Slack, Discord, Gemini, etc.)
- **User Research** - Customer insights and feedback
- **Dependency Map** - Cross-team dependencies
- **Out of Scope** - Explicitly state what will NOT be covered

## Writing Style Principles

### 1. Problem-First Approach
- Always establish the user problem or business need before proposing solutions
- Ground problems in evidence: customer names, incident numbers (IcMs), DSAT data, VIP escalations
- Use specific examples: "Goldman Sachs," "Volvo Group," "Kaiser Permanente," not generic "customers"

**Example:**
```
User Asks/Escalations
We have seen a number of escalations across emails and Teams asking for [feature].
This includes escalations from VIP customers such as Goldman Sachs, Volvo Group,
and StarHub Ltd.

Related IcMs:
- Incident 608746463: [Clifford Chance LLP] [Online] [NONURGENT]: [Description]
- Incident 595445924: [Volvo Group] [S500] [Online]: [Description]
```

### 2. Scope Clarity
- Define "In Scope" vs "Out of Scope" early in the document
- Prevents scope creep and sets clear boundaries
- Be explicit about what will NOT be covered

### 3. Scenario-Driven Specifications
- Use concrete user scenarios with sample utterances rather than abstract requirements
- Format as tables with columns: Scenario | Sample Utterance | Details | Priority

**Example:**
```
| Scenario | Sample Utterance | Mailbox/Folder | Priority |
|----------|------------------|----------------|----------|
| No mailbox specified | What's hot in my mailbox? | Primary mailbox | Supported |
| Mailbox by display name | What's hot in Project Avalon mailbox? | Project Avalon | P0 |
| Mailbox by email | What's hot in projectavalon@microsoft.com? | Project Avalon | P0 |
```

### 4. Table-Heavy Presentation
Use tables extensively for:
- **Project plans**: Task | Team | DRI | ETA
- **Requirements**: Requirement | Level | Notes
- **Query sets**: Query Pattern | Level | Description
- **Roles & Responsibilities**: Role/Responsibility | Team | DRI | Agreement
- **Scenarios**: Scenario | Sample Utterance | Expected Behavior | Priority

### 5. Priority and Severity Labeling
- Mark items clearly: **P0** (critical), **P1** (high), **P2** (medium), **Out of scope**
- Or use: **Critical**, **Important**, **Nice-to-have**
- Always make priorities explicit

### 6. Evaluation-Oriented Approach
Include evaluation criteria with:
- **Data Set** - What data is needed for testing
- **Query Set** - Sample queries with priority levels
- **Assertions** - What defines success

**Example:**
```
Evaluation Set

Data Set
More than 30 emails from a person, around a topic spread over a period of more than 2 years.

Query Set
| Query Pattern | Level |
|---------------|-------|
| Find oldest email in my inbox | Critical |
| Summarize all emails around <topic> in chronological order | Critical |
| List all emails from <person> displaying the earliest first | Critical |
```

### 7. Direct and Economical Language
- No fluff or unnecessary elaboration
- Get to the point quickly
- Use clear, functional sentences
- Avoid marketing language or superlatives

**Bad:** "This innovative, groundbreaking feature will revolutionize how users..."
**Good:** "Users need to search shared mailboxes. Current limitations prevent this."

### 8. North Star Framing
- Articulate aspirational end-states while acknowledging current constraints
- Use "North Star" terminology to describe ideal future state

**Example:**
```
User expectations - our North Star
Users expect to successfully find Files shared as attachments. As product owners,
our aspiration is to help find these Files with the highest accuracy.

Current Limitations
Currently email as an entity is not available as a data source in Copilot Studio...
```

### 9. Collaborative Cross-Team Language
- Frequent references to partner teams, dependencies, and DRIs
- Write as a coordinator across teams
- Use "we" when referring to cross-functional work

### 10. Open Questions Section
- Explicitly call out unresolved questions rather than glossing over gaps
- Format as bullet points or numbered list
- Shows transparency and invites input

## Document Formatting

### Headers
- Use clear hierarchical headers (H1, H2, H3)
- Keep header text concise and descriptive
- Use title case for major sections

### Lists
- Use bullet points for non-sequential items
- Use numbered lists for sequential steps or priorities
- Keep list items parallel in structure

### Code/Technical Examples
- Use inline code for: `API names`, `function names`, `file paths`
- Use code blocks for: sample queries, configuration examples, command sequences

### References and Links
- Include a "References" section near the end
- Link to related documents, specs, and external resources
- Use descriptive link text, not bare URLs

## Microsoft-Specific Conventions

### Terminology
Use Microsoft-internal terminology appropriately:
- **DSATs** - Customer dissatisfaction metrics
- **LT** - Leadership team
- **IcM** - Incident management
- **DRI** - Directly responsible individual
- **ETA** - Estimated time of arrival/completion
- **VIP** - Very important person/customer
- **LU** - Language understanding
- **SERP** - Search engine results page
- **KQL** - Keyword query language

### Customer References
- Always use real customer names when available (with appropriate permissions)
- Include company names, not just "enterprise customers"
- Reference specific tenant feedback

### Feature Links
- Link to ADO work items: "Feature 5352886: [Description]"
- Include tracking numbers for incidents and escalations

## Creating New Documents

When asked to create a new specification document:

1. **Start with title and introduction** - What is this feature/initiative?
2. **Establish the problem** - Why does this matter? What evidence supports it?
3. **Define scope** - What will/won't be covered?
4. **Present solution approach** - How will we solve it?
5. **Detail requirements** - What specifically needs to happen?
6. **Define evaluation** - How will we measure success?
7. **Create project plan** - Who does what by when?
8. **List open questions** - What's unresolved?
9. **Add references** - Link to supporting materials
10. **Append technical details** - Deep dives go in appendix

## Formatting Existing Documents

When asked to format an existing document:

1. **Audit structure** - Does it follow the standard section order?
2. **Extract tables** - Convert prose into tables where appropriate
3. **Add priorities** - Label items as P0/P1/P2 or Critical/Important
4. **Clarify scope** - Add "In Scope" / "Out of Scope" if missing
5. **Add evaluation criteria** - Include query sets and assertions if absent
6. **Format consistently** - Ensure headers, lists, and tables are uniform
7. **Add missing sections** - Include Open Questions, References, or Appendix if needed
8. **Strengthen evidence** - Add customer names, incident numbers, compete data

## Common Document Types

### Approach Note
Focus: Directional alignment before detailed spec
- Shorter than full spec (5-10 pages)
- Emphasis on problem statement and solution options
- Include "out of scope" prominently
- Target audience: Leadership team for approval

### Feature Specification
Focus: Detailed requirements for engineering implementation
- Complete section structure
- Detailed requirements with acceptance criteria
- Comprehensive evaluation plan
- Clear project plan with DRIs and ETAs

### Evaluation Plan
Focus: Testing strategy and quality assurance
- Heavy emphasis on query sets and assertions
- Data set requirements
- Roles and responsibilities for execution
- Success metrics and dashboarding

### Rollout Plan
Focus: Phased deployment strategy
- Timeline with milestones
- Risk mitigation
- Monitoring and rollback procedures
- Communication plan

## Quality Checklist

Before finalizing any document, verify:
- [ ] Problem is grounded in evidence (customer names, IcMs, DSATs)
- [ ] Scope is explicitly defined (in/out of scope)
- [ ] Requirements are specific and actionable
- [ ] Scenarios include sample utterances
- [ ] Priorities are labeled (P0/P1/P2 or Critical/Important)
- [ ] Project plan includes DRIs and ETAs
- [ ] Tables are used for complex information
- [ ] Open Questions section exists (even if empty)
- [ ] References section includes related documents
- [ ] Appendix contains technical deep-dives
- [ ] Language is direct and economical
- [ ] Cross-team dependencies are identified
