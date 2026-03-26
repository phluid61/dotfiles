---
name: generate-docs
description: Analyses repositories of any technology stack and generates comprehensive, multi-audience documentation for developers, DevOps, and business stakeholders. Use when user wants to generate, create, or update project documentation.
---

# Repository Documentation Generation

## Quick start

1. Invoke this skill on a repository
2. The skill analyses the codebase, detects the technology stack, and asks you clarifying questions
3. After you answer, it generates 11 documentation files in `docs/` plus an updated `README.md`

## Workflows

### Generate documentation for a repository

1. **Detect** — Identify the technology stack and CI/CD platform ([STACK-HINTS.md](STACK-HINTS.md))
2. **Analyse** — Run Phases 1–8 to extract metadata, dependencies, architecture, database, business rules, configuration, build/deployment, and testing ([REFERENCE.md — Analysis Phases](REFERENCE.md#analysis-phases))
3. **Collect questions** — Identify low-confidence areas needing clarification
4. **Ask mandatory questions** — You MUST ask at minimum:
   - External URLs (Wiki, Repository, Jira/Issue Tracker)
   - Log file locations per environment
   - Database name/identifier (if a database layer exists)
   - Any business rules whose purpose is unclear
   - Any external system integrations not fully documented in code
5. **Wait for answers** — Do NOT proceed to generation until the user has answered
6. **Generate** — Produce all 11 documentation files ([REFERENCE.md — Generation Components](REFERENCE.md#generation-components))
7. **Validate** — Run the [Validation Checklist](#validation-checklist)
8. **Report** — Summary of what was generated, stacks detected, and confidence levels

> **HARD RULE:** If step 4 produces zero questions, your analysis was insufficient. Go back and look harder. Every project has unknowns that require human input.

## Output structure

```
README.md
docs/README.md
docs/DEVELOPER_GUIDE.md
docs/ARCHITECTURE.md
docs/DATABASE.md
docs/API.md
docs/BUSINESS_RULES.md
docs/CONFIGURATION.md
docs/DEPLOYMENT.md
docs/DEPENDENCIES.md
docs/TROUBLESHOOTING.md
```

All 11 documents are always generated. If a document's subject is not applicable to the repository (e.g. DATABASE.md for a project with no database layer), generate the file with a brief explanation of why the section is not applicable rather than omitting it.

---

## Preservation rules

> **CRITICAL — READ THIS CAREFULLY AND OBEY:**

- **ABSOLUTELY NEVER** read, edit, overwrite, or touch `AGENTS.md` — not even to "improve" it
- **ABSOLUTELY NEVER** read, edit, overwrite, or touch `.github/copilot-instructions.md` — not even to "improve" it
- These two files are OFF LIMITS. Do not open them for editing. Do not include them in any file creation or modification operations.
- If you find yourself about to modify either of these files, STOP. You are violating a critical rule.
- **PRESERVE** manual sections marked with `preserve: true`
- **MERGE** new content with existing docs, don't overwrite entirely
- Only create or modify files listed in the Output structure section above

---

## When to ask clarifying questions

Use `ask_questions` tool when encountering uncertainty. High-quality documentation requires accurate context, not plausible guesses.

> **MANDATORY:** You MUST use `ask_questions` at least once before generating any documentation. Every project has context that cannot be inferred from code alone. If you believe you have no questions, you are wrong — re-examine your analysis for gaps in external URLs, business context, infrastructure details, and deployment environments.

Always ask questions individually, so the user can provide a single response to each question.

### ALWAYS ask about (mandatory questions)

These questions MUST be asked for every project. Do not skip them even if you think you can infer the answers:

1. **External URLs** — Wiki URL, Repository URL, Jira/Issue Tracker URL (for inclusion in README.md and docs)
2. **Project Purpose & Audience** — If not clear from code/config
3. **Log File Locations** — Where application and server logs are written (do not guess or make up paths)
4. **External Systems & Integrations** — What they are, what they do, and their URLs
5. **Business Context for Technical Code** — Why business rules exist
6. **Organisation-Specific Terms** — Acronyms, abbreviations
7. **Missing or Ambiguous Configuration** — External systems, deployment targets
8. **Database Name/Identifier** — If a database layer is present (do not guess or infer)

### NEVER guess about

- The business purpose of features
- Why specific business rules exist
- What external systems are or do
- What database tables contain (beyond column names)
- Project-specific acronyms or terminology
- Whether code is production, experimental, or deprecated
- **Log file locations or paths** — ALWAYS ask the user
- **External URLs** (wiki, repository, Jira) — ALWAYS ask the user
- **Server names, hostnames, or infrastructure details** — ALWAYS ask the user

### Confidence thresholds

| Analysis Area | Confidence < 70% | Confidence 70–85% | Confidence > 85% |
|---------------|------------------|-------------------|------------------|
| **Project Purpose** | Ask user | Generate + flag for review | Auto-generate |
| **Business Rules** | Ask user | Generate + flag for review | Auto-generate |
| **Technical Stack** | Ask user if critical gaps | Generate with notes | Auto-generate |
| **Database Schema** | Ask user for table purposes | Infer + flag uncertain | Auto-generate |
| **External Systems** | ALWAYS ask | ALWAYS ask | Auto-generate if obvious |
| **External URLs** | ALWAYS ask | ALWAYS ask | ALWAYS ask |
| **Log Locations** | ALWAYS ask | ALWAYS ask | ALWAYS ask |
| **Database Name** | ALWAYS ask | ALWAYS ask | ALWAYS ask |

### Low confidence marker format

When confidence is low and clarification isn't available, mark the section (see [EXAMPLES.md](EXAMPLES.md#low-confidence-marker) for the template).

---

## Validation checklist

After generation, validate:

1. **Structure:** All required files exist
2. **Links:** All markdown links point to real files/sections
3. **Content:** No placeholder text (TODO, TBD, [[]])
4. **Tables:** All tables have content rows (or an explicit "not applicable" statement)
5. **Code blocks:** Have language specified (but should be minimal — prefer references over code)
6. **Low confidence:** Sections marked appropriately
7. **Cross-references:** Tables mentioned in BUSINESS_RULES exist in DATABASE. All inter-table markdown links (`[table_name](#table_name)`) in DATABASE.md — both in blurbs and in the Details column — resolve to actual `###` table headings within the same file
8. **No code snippets:** Verify BUSINESS_RULES.md, CONFIGURATION.md, and DATABASE.md contain references, not code blocks
9. **Preservation:** Confirm `AGENTS.md` and `.github/copilot-instructions.md` were NOT modified
10. **Questions were asked:** Confirm the agent asked the user questions before generating
11. **External URLs:** Confirm README.md contains the Wiki, Repository, and Jira URLs from user input
12. **No fabricated paths:** Confirm log locations, server names, and infrastructure details came from user input, not guesses
13. **Not-applicable docs:** Confirm any non-applicable documents state this explicitly rather than containing invented content

---

## Quality standards

- Use proper markdown formatting
- Insert a blank line before the first item of any list (ordered or unordered)
- Use Mermaid diagrams for architecture visualisation
- **Do NOT include code snippets or code examples in documentation** — instead, reference source file paths and method/function names so readers can navigate to the code themselves
- Use a format appropriate to the language for code references (e.g. `ClassName.methodName()` in `path/to/File.java`, `Module::function()` in `path/to/file.pm`, `ClassName::method()` in `path/to/file.php`)
- Link to source files where relevant
- Be concise but complete
- Write for the target audience of each document
- When in doubt, ask the user rather than generating plausible-sounding but incorrect content

---

## Detailed reference

- **Analysis phases and generation components:** [REFERENCE.md](REFERENCE.md)
- **Stack-specific analysis guidance:** [STACK-HINTS.md](STACK-HINTS.md) — covers Java/Maven, Perl, PHP, PHP+WordPress, Ruby, AWS IaC, GitHub Actions, BitBucket Pipelines
- **Worked examples for all output formats:** [EXAMPLES.md](EXAMPLES.md)
