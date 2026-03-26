# Reference — Repository Documentation Generation

Detailed analysis phases and generation components for the generate-docs skill. Read [SKILL.md](SKILL.md) first for the workflow, rules, and validation checklist.

---

## Analysis Phases

Execute these phases in order before generating documentation. Consult [STACK-HINTS.md](STACK-HINTS.md) for technology-specific guidance at each phase.

### Phase 0: Stack Detection

See [STACK-HINTS.md — Stack Detection](STACK-HINTS.md#stack-detection-phase-0) for the full marker tables and detection logic.

### Phase 1: Project Metadata

**Extract from (adapt to detected stack):**

- Version control config (`.git/config`) → repository URL
- Build/package manifest (see Stack Hints for file names) → project name, version, description
- README or similar → existing project description

### Phase 2: Technology Stack

**Extract from the build/package manifest and source files:**

- Language version requirements
- Framework and library dependencies with versions
- Build tool plugins and configuration
- Runtime dependencies vs development/test dependencies

**Categorise dependencies into:**

- Core Framework (primary application framework)
- Data Access (database drivers, ORMs, query builders)
- Custom/Internal Libraries (organisation-specific)
- Testing (test frameworks, mocking libraries)
- Build & Deployment Tools
- External Service Clients (API clients, SDKs)

### Phase 3: Architecture

**Extract from source files and configuration:**

- Entry points (controllers, routes, handlers, main files)
- Service/business logic layer
- Data access layer (DAOs, repositories, models, ORM mappings)
- Configuration files and their roles
- View/template layer

**Map:**

- Presentation layer (controllers, views, templates, static assets)
- Business logic layer (services, domain models)
- Data access layer (repositories, DAOs, query objects)
- Integration layer (API clients, message queues, external service adapters)

### Phase 4: Database Layer

**Extract from source code and configuration:**

- Database connection configuration (connection strings, JNDI, environment variables)
- ORM models/entities or raw SQL queries
- Table names, column names (regex extraction from queries or model definitions)
- Migration files (schema history)

**Capture:**

- Table names and operations (INSERT, SELECT, UPDATE, DELETE)
- Column names from queries or model definitions
- Named SQL query constants or ORM scope names for use in blurbs and table descriptions
- Database-specific features (vendor-specific types, functions, extensions)

### Phase 5: Business Rules

**Extract from:**

- Code comments, docstrings, and documentation annotations
- Constants and enums → configuration values
- Validation logic in methods
- Default values and preference settings

**Identify:**

- Validation rules and constraints
- Default values and their purposes
- Access control rules
- Feature toggles and flags
- Domain-specific calculations or transformations

### Phase 6: Configuration

**Extract from:**

- Environment-specific configuration files
- Environment variable references in code and CI/CD
- Application configuration (framework config files, settings modules)
- Logging configuration
- Infrastructure configuration (web server, application server, container)

### Phase 7: Build & Deployment

**Extract from:**

- CI/CD pipeline files (see Stack Hints for file locations)
- Build scripts and commands
- Deployment triggers (branch patterns, tags)
- Build artefacts (what is produced and where)
- Shell scripts invoked by the pipeline (discover by parsing the pipeline file)

### Phase 8: Testing

**Extract from:**

- Test directories and files (see Stack Hints for conventions)
- Test frameworks in use
- CI/CD pipeline steps that run tests
- Linting and static analysis configuration

**Determine and document:**

- Whether a formal test suite exists (unit tests, integration tests, test framework)
- What automated validation is performed (linting, type checking, syntax checking)
- Whether all file types are covered by linting (check for commented-out or missing checks)
- What manual validation steps are required
- Test coverage reporting (if configured)

---

## Generation Components

### Component 1: README.md

**Purpose:** Quick orientation for all audiences

**Sections:**

1. Project Title and Description
2. Badges (build status, version)
3. Key Features (3–5 bullets) — **Ask if unclear**
4. Technology Stack (auto-generated table)
5. Quick Start (build commands)
6. Project Links (Wiki, Repository, Jira) — **MUST ask user for these URLs**
7. Documentation Guide (role-based navigation)

**Strategy:**

- Extract project name from the build manifest (adapt to stack)
- Extract description from the manifest or **ask user**
- Generate tech stack table from dependencies
- Extract build commands from build configuration
- **MUST ask user** for external URLs: Wiki URL, Repository URL, and Jira/Issue Tracker URL
- Include a "Project Links" section (see [EXAMPLES.md](EXAMPLES.md#readmemd--project-links-section))

### Component 2: docs/DEVELOPER_GUIDE.md

**Purpose:** Get new developers productive quickly

**Sections:**

1. Prerequisites (language version, build tool, IDE)
2. Getting Started (clone, build, test)
3. Project Structure (directory tree with purposes)
4. Development Workflow (Git workflow, local development notes)
5. Coding Conventions (naming, patterns, logging)
6. Adding New Features (reference to existing patterns in codebase, not full code examples)
7. Testing (framework, patterns, coverage requirements)
8. Common Development Tasks (reference to relevant source files and methods)

**Strategy:**

- Extract language/runtime version from build configuration
- **Ask user** for version if not specified in config
- Map directory structure to descriptions
- Identify common patterns (utilities, enums, interfaces, base classes)
- Extract test conventions from test files
- Reference source files and methods instead of including code snippets
- For "Adding New Features", point to an existing example in the codebase rather than writing sample code

### Component 3: docs/ARCHITECTURE.md

**Purpose:** Understand system design at a high level

**Sections:**

1. System Overview
2. Component Architecture (Mermaid diagram — see [EXAMPLES.md](EXAMPLES.md#architecturemd--mermaid-diagram))
3. Application Architecture (framework-specific structure — e.g. MVC, plugin system, middleware pipeline)
4. Integration Architecture (external systems)
5. Security Architecture (auth/authz flow)
6. Data Flow (request → response paths)
7. View Layer (templates, static assets, frontend build)

Adapt the Mermaid diagram to the actual architecture discovered. The template is a starting point, not a constraint.

### Component 4: docs/DATABASE.md

**Purpose:** Document database name, tables, columns, and data access patterns

> **IMPORTANT:** This document should be a concise reference, NOT a reproduction of SQL queries or ORM code. Do not include query code. Reference the source file and method/function name only.

**MUST ask user for:** The database name/identifier. Do not guess or infer it.

**Sections:**

1. Database Overview (name/identifier, type, connection method)
2. Data Access Layer (list of DAO/repository/model classes with brief description of responsibility)
3. Tables — one `###` subsection per database table (see Per-Table Section Format below)
4. Database-Specific Features (vendor-specific types, functions, extensions — if applicable)

**If no database layer is detected:** Generate the file with a statement such as "This project does not use a database" and note any data persistence mechanisms that do exist (file storage, external APIs, etc.).

**Per-Table Section Format:**

Each database table discovered gets a `###` heading using the table name as a markdown anchor. Group related tables under `##` subheadings for readability.

Below each `###` heading, include:

1. **A blurb** — a reference to the named query constants or method names that touch the table, plus a plain-English sentence describing the table's role in context.

2. **A markdown table** with three columns — one row per column **per operation**:

   | Column | Operation | Details |
   |--------|-----------|---------|

   - **Column** — the column name in backticks
   - **Operation** — one of: `Join`, `Predicate`, `Selected`, `Inserted`
   - **Details** — context depending on operation (see [EXAMPLES.md](EXAMPLES.md#databasemd--per-table-format) for worked examples)

**Rules:**

- One `###` subsection per database table
- Blurb references named query constants where available; fall back to `ClassName.methodName()` or `filename:function_name()` for inline queries
- Blurb includes a plain-English sentence describing the table's purpose in the context of the queries
- One row per column **per operation** — if a column is used as both a Join and a Predicate, it gets two rows
- The four valid Operation values are: `Join`, `Predicate`, `Selected`, `Inserted`
- For **Join** details: always include a markdown link to the target table heading (e.g. `[table_name](#table_name)`)
- For **Predicate** details: describe naturally what the column is matching — mention literal values where applicable (e.g. "status is 'active'") or describe the input parameter (e.g. "Matches the user-supplied customer ID")
- For **Selected** details: describe what the column is used to display or return to the user
- For **Inserted** details: describe what data the column stores
- Use markdown links (`[table_name](#table_name)`) when referencing other tables so readers can navigate between related tables
- If table purpose is unclear, ask the user or mark as LOW CONFIDENCE
- Do NOT include SQL code, ORM code, or query snippets

### Component 5: docs/API.md

**Purpose:** Document all available endpoints and interfaces

**Sections (adapt to detected stack):**

1. Web Endpoints (routes, controllers, handlers)
2. API Endpoints (REST, GraphQL, RPC)
3. CLI Commands (if applicable)
4. Background Jobs / Scheduled Tasks (if applicable)
5. Request/Response Documentation
6. Common Parameters

See [EXAMPLES.md](EXAMPLES.md#apimd--endpoint-table) for the endpoint table format.

**If no API or endpoints are detected:** Generate the file with a statement explaining what interfaces the project does expose (e.g. "This project is a library consumed via…" or "This project is infrastructure-only with no HTTP endpoints").

### Component 6: docs/BUSINESS_RULES.md

**Purpose:** Document business rules with plain-English explanations and source code references

> **IMPORTANT:** Do NOT include code snippets in this document. Describe each rule in plain English and provide a reference to the source file and method/function where the rule is implemented. The reader can navigate to the code themselves.

**Sections:** Organise rules by domain area as discovered during analysis. Common groupings include:

- Validation and Constraints
- Access Control (authentication, authorisation)
- Data Processing and Transformation
- User Preferences and Defaults
- Feature Toggles and Flags
- Domain-Specific Logic (as discovered)

Use `##` headings for domain groups and `###` headings for individual rules. See [EXAMPLES.md](EXAMPLES.md#business_rulesmd--rule-format) for the per-rule format.

**Strategy:**

- Extract constants representing business rules
- Analyse validation logic in service/model methods
- **Ask questions when business reason unclear**
- Describe rules in plain English — no code blocks, no code snippets
- Always include file path and method/function name as a reference

### Component 7: docs/CONFIGURATION.md

**Purpose:** Understand configuration across environments

**Sections:**

1. Environment Profiles (table with profile → configuration)
2. Build-Time Configuration
3. Environment Variables (keys, purposes, which are secrets)
4. Application Configuration Files (purpose of each)
5. Infrastructure Configuration (web server, container, etc.)
6. Logging Configuration (levels, locations, rotation)

### Component 8: docs/DEPLOYMENT.md

**Purpose:** Enable deployment to any environment

**Sections:**

1. Build Process (prerequisites, commands, artefacts)
2. CI/CD Pipeline (workflows, triggers, automation)
3. CI/CD Variables (extracted from pipeline files — see below)
4. Manual Deployment Steps (if needed)
5. Environment Configuration (per environment)
6. External Dependencies (databases, search engines, caches)
7. Pre-Deployment Checklist (auto-generated)
8. Post-Deployment Verification (standard checks)
9. Rollback Procedures

**CI/CD Variables Section:**

Parse all CI/CD pipeline files and any shell scripts they invoke to extract:

- All deployment environment names referenced
- All runner labels or execution targets per step
- All environment variables referenced (search for `$VARNAME` and `${VARNAME}` patterns in shell scripts)
- All secrets and variables referenced (e.g. `secrets.*`, `vars.*` in GitHub Actions; secured/deployment variables in BitBucket Pipelines)

See [EXAMPLES.md](EXAMPLES.md#deploymentmd--cicd-variables-table) for the table format. If the purpose of a variable cannot be determined from context, mark it with "(ask team)" rather than guessing.

### Component 9: docs/DEPENDENCIES.md

**Purpose:** Track all dependencies, versions, and purposes

**Sections (as tables, adapt categories to detected stack):**

1. Core Framework Dependencies
2. Application Dependencies
3. Custom/Internal Libraries
4. External Services and Integrations
5. Development Dependencies
6. Build & Deployment Tools
7. Known Issues and Limitations

**Dependency Table Format:**

```markdown
| Name | Version | Source | Purpose |
|------|---------|--------|---------|
| package-name | x.y.z | Registry/source | Description |
```

For stacks with richer metadata (e.g. Maven's group/artifact/scope), expand the table columns accordingly.

### Component 10: docs/TROUBLESHOOTING.md

**Purpose:** Help resolve common problems

**Sections:**

1. Build Issues
2. Deployment Issues
3. Runtime Issues
4. Performance Issues
5. Common Error Messages (pattern → solution)
6. Log Analysis (locations, debug mode)
7. Testing Issues (test failures, mocking)
8. Integration Issues (external systems)
9. FAQ (extracted from code comments)
10. Getting Help (contacts, channels)

> **CRITICAL:** Do NOT make up or guess log file locations. You MUST ask the user where log files are stored for each environment. If the user does not provide log locations, mark the Log Analysis section as LOW CONFIDENCE and leave placeholders for the user to fill in.

### Component 11: docs/README.md

**Purpose:** Documentation navigation guide

**Sections:**

1. Documentation Inventory (list all docs)
2. Quick Navigation by Role
3. Documentation Descriptions Table
4. External Resources (wiki, Jira)
