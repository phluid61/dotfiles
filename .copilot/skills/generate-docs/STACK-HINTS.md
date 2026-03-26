# Stack Hints

Technology-specific guidance for each known stack. During each analysis phase and generation component, consult the relevant stack hints to know **where to look** and **what patterns to expect**.

If a repository matches multiple stacks, apply all relevant hints.

---

## Stack Detection (Phase 0)

Before any other analysis, identify the technology stack by scanning for marker files and patterns. The detected stack determines which hints below apply throughout subsequent phases.

### Application Stack Markers

Scan for these in priority order:

| Marker | Stack |
|--------|-------|
| `pom.xml`, `build.gradle` | Java/Maven or Java/Gradle |
| `Makefile.PL`, `cpanfile`, `*.pm` in root or `lib/` | Perl |
| `composer.json` | PHP (inspect for WordPress indicators) |
| `wp-content/`, `wp-config.php`, `style.css` with `Theme Name:` | PHP + WordPress |
| `*.php` without `composer.json` | PHP (standalone) |
| `Gemfile`, `*.gemspec` | Ruby |
| `package.json` | Node.js / JavaScript / TypeScript |
| `requirements.txt`, `setup.py`, `pyproject.toml`, `Pipfile` | Python |
| `template.yaml`, `template.yml` (SAM), `*.tf`, `Dockerfile`, `docker-compose.yml` | AWS IaC / Infrastructure |
| `go.mod` | Go |
| `Cargo.toml` | Rust |
| `*.sln`, `*.csproj` | .NET / C# |

### CI/CD Markers

| Marker | CI/CD Platform |
|--------|----------------|
| `.github/workflows/*.yml` | GitHub Actions |
| `bitbucket-pipelines.yml` | BitBucket Pipelines |
| `.gitlab-ci.yml` | GitLab CI |
| `Jenkinsfile` | Jenkins |

A repository may match multiple stacks (e.g. a PHP application with Docker and GitHub Actions). Record all matches and apply all relevant hints.

If no known stack is detected, proceed with generic heuristics — the skill still functions without stack hints.

---

## Java / Maven

**Phase 1 — Project Metadata:**

- `pom.xml` → project name (`artifactId`), version, description, parent project
- `osgi.bnd` → OSGi bundle info, web context path
- Package structure → base package name

**Phase 2 — Technology Stack:**

- `pom.xml` `<dependencies>` → frameworks, libraries, versions
- `pom.xml` `<build><plugins>` → compilation, testing, bundling tools
- `maven-compiler-plugin` → Java version
- Identify framework versions (Spring, Liferay, Portlet API, etc.)

**Phase 3 — Architecture:**

- Controllers: scan for `@Controller`, `@RestController`, `@RequestMapping`, `@RenderMapping`
- Services: scan for `@Service`, `@Component`
- DAOs: scan for `@Repository`
- Spring XML configs → bean definitions, component scanning
- `web.xml`, `portlet.xml` → servlet/portlet mappings

**Phase 4 — Database:**

- JNDI lookups in Spring XML → datasource names
- DAO classes → SQL queries (parse SELECT/INSERT/UPDATE/DELETE)
- JPA entities → `@Entity`, `@Table`, `@Column` annotations
- JDBC template type → named parameters vs positional

**Phase 6 — Configuration:**

- Maven profiles from `pom.xml`
- Properties files (`.properties`, `.yml`) → environment-specific config
- Spring XML → bean configs, message sources
- `log4j.xml` / `log4j2.xml` / `logback.xml` → logging config

**Phase 7 — Build & Deployment:**

- `.github/workflows/*.yml` or `bitbucket-pipelines.yml` → CI/CD
- Maven build commands from profiles
- Build artefacts: WAR/JAR file location in `target/`

**Phase 8 — Testing:**

- Test classes in `src/test/java`
- Test frameworks: JUnit, Mockito, Spring Test
- Surefire/Failsafe plugin reports

**Dependencies table columns:**

`| Group ID | Artifact ID | Version | Scope | Purpose |`

---

## Perl

**Phase 1 — Project Metadata:**

- `Makefile.PL` or `dist.ini` or `META.json` → project name, version
- `.git/config` → repository URL
- For EPrints repositories: `archive/cfg/` is the primary configuration root

**Phase 2 — Technology Stack:**

- `use` statements in `.pl` and `.pm` files → Perl modules
- `@ISA` or `use parent` → inheritance
- `cpanfile` or `Makefile.PL` → CPAN dependencies
- For EPrints: `archive/cfg/cfg.d/*.pl` and `archive/cfg/plugins/EPrints/Plugin/**/*.pm`

**Phase 3 — Architecture:**

- For EPrints: configuration in `archive/cfg/cfg.d/`, plugins in `archive/cfg/plugins/`, workflows in `archive/cfg/workflows/`
- For generic Perl: `lib/` for modules, `bin/` or `script/` for entry points, `t/` for tests

**Phase 4 — Database:**

- DBI usage → database connections
- Raw SQL in Perl strings
- For EPrints: `EPrints::Search` objects, `$c->{...}` config hashes

**Phase 6 — Configuration:**

- For EPrints: `archive/cfg/cfg.d/*.pl` → `$c->{...}` configuration hashes
- Apache config: `apachevhost.conf`, `apachevhost_ssl.conf`
- Environment-specific config in `conf/` or similar

**Phase 7 — Build & Deployment:**

- `bitbucket-pipelines.yml` or `.github/workflows/*.yml` → CI/CD
- Deployment tools: rsync, envsubst, perl, git
- Shell scripts invoked by the pipeline

**Phase 8 — Testing:**

- Test files in `t/` directory
- Test frameworks: Test::More, Test::Most, prove
- Syntax checking via `perl -c`

---

## PHP (Generic)

**Phase 1 — Project Metadata:**

- `composer.json` → project name, description, version, type
- `.git/config` → repository URL

**Phase 2 — Technology Stack:**

- `composer.json` `require` → PHP version, framework, libraries
- `composer.json` `require-dev` → development/testing dependencies
- `composer.lock` → locked versions
- Identify framework: Laravel (`artisan`), Symfony (`bin/console`), CodeIgniter, CakePHP, Slim, or custom/standalone

**Phase 3 — Architecture:**

- For Laravel: `app/Http/Controllers/`, `app/Models/`, `routes/`, `resources/views/`
- For Symfony: `src/Controller/`, `src/Entity/`, `config/routes/`, `templates/`
- For standalone: scan for common patterns — MVC directories, front controller (`index.php`), autoloader (`vendor/autoload.php`)

**Phase 4 — Database:**

- ORM models/entities (Eloquent, Doctrine)
- Migration files (`database/migrations/` for Laravel, `migrations/` for Doctrine)
- Raw SQL in PHP strings (PDO, mysqli)
- Database config in `.env`, `config/database.php`, or framework config

**Phase 6 — Configuration:**

- `.env` / `.env.example` → environment variables
- Framework config directory (`config/` for Laravel/Symfony)
- `php.ini` directives if referenced

**Phase 7 — Build & Deployment:**

- `composer install` / `composer install --no-dev` for production
- Asset compilation (Laravel Mix, Vite, Webpack)
- CI/CD pipeline files

**Phase 8 — Testing:**

- `phpunit.xml` or `phpunit.xml.dist` → PHPUnit configuration
- Test directories: `tests/`, `test/`
- Static analysis: PHPStan, Psalm, PHP_CodeSniffer

---

## PHP + WordPress

Inherits all PHP (Generic) hints, plus:

**Phase 1 — Project Metadata:**

- `style.css` header (for themes) → Theme Name, Version, Description
- Plugin header comment in main PHP file → Plugin Name, Version, Description
- `readme.txt` → WordPress.org metadata

**Phase 2 — Technology Stack:**

- WordPress core version requirement (if specified)
- Theme/plugin dependencies
- WordPress-specific libraries (WP_Query, WP_REST_API, etc.)

**Phase 3 — Architecture:**

- For themes: `functions.php`, template hierarchy (`single.php`, `page.php`, `archive.php`, etc.), `template-parts/`
- For plugins: main plugin file, `includes/`, `admin/`, `public/`, hooks and filters
- Shortcodes, widgets, custom post types, taxonomies
- REST API endpoints registered via `register_rest_route()`
- WP-CLI commands (if any)

**Phase 4 — Database:**

- `$wpdb` queries → direct database access
- Custom tables created in activation hooks
- WordPress options API (`get_option`, `update_option`)
- Post meta, term meta, user meta usage

**Phase 6 — Configuration:**

- `wp-config.php` → database credentials, debug settings, salts
- Theme Customizer settings
- Plugin settings pages (options stored in `wp_options`)

---

## Ruby (Generic)

**Phase 1 — Project Metadata:**

- `Gemfile` → project dependencies (Ruby version if specified)
- `*.gemspec` → gem name, version, description
- `.ruby-version` → Ruby version
- `.git/config` → repository URL

**Phase 2 — Technology Stack:**

- `Gemfile` → gems with groups (development, test, production)
- `Gemfile.lock` → locked versions
- Identify framework: Rails (`Gemfile` includes `rails`), Sinatra, Hanami, Rack, or standalone

**Phase 3 — Architecture:**

- For Rails: `app/controllers/`, `app/models/`, `app/views/`, `config/routes.rb`
- For Sinatra: route definitions in `app.rb` or similar
- For standalone: `lib/` for modules, `bin/` for executables

**Phase 4 — Database:**

- ActiveRecord models and associations
- Migration files in `db/migrate/`
- `db/schema.rb` or `db/structure.sql` → current schema
- Database config in `config/database.yml`
- Sequel, ROM, or other ORM if not Rails

**Phase 6 — Configuration:**

- `config/` directory (Rails) → environment-specific files
- `.env` files (via dotenv gem)
- `config/credentials.yml.enc` (Rails encrypted credentials)
- `config/initializers/` (Rails)

**Phase 7 — Build & Deployment:**

- `bundle install` for dependencies
- Asset pipeline / Webpacker / esbuild / importmap
- CI/CD pipeline files
- Deployment: Capistrano, Kamal, Docker, Heroku

**Phase 8 — Testing:**

- `spec/` → RSpec; `test/` → Minitest
- `Rakefile` → test tasks
- `.rspec` → RSpec configuration
- Static analysis: RuboCop, Brakeman (security)

---

## AWS Infrastructure-as-Code

**Phase 1 — Project Metadata:**

- `template.yaml` / `template.yml` (SAM) → stack description
- `*.tf` (Terraform) → provider and module definitions
- `docker-compose.yml` → service definitions
- `Dockerfile` → base image, build stages
- `samconfig.toml` / `backend.tf` → deployment configuration

**Phase 2 — Technology Stack:**

- CloudFormation/SAM resource types
- Terraform providers and modules
- Docker base images and build tools
- Lambda runtimes (if applicable)

**Phase 3 — Architecture:**

- For CloudFormation/SAM: `Resources` section → service inventory
- For Terraform: resource blocks, module composition, data sources
- For Docker: service topology from `docker-compose.yml`, network definitions
- Map: compute resources, storage, networking, IAM roles

**Phase 4 — Database:**

- RDS, DynamoDB, ElastiCache, or other managed database resources
- Database parameter groups and configuration
- Backup and retention policies

**Phase 5 — Business Rules:**

- IAM policies → access control rules
- Security group rules → network access rules
- Lambda function logic (if source is included)
- Step Functions state machines

**Phase 6 — Configuration:**

- CloudFormation parameters and mappings
- Terraform variables and `terraform.tfvars`
- Docker environment variables
- SSM Parameter Store / Secrets Manager references
- Per-environment overrides (e.g. `environments/dev/`, `environments/prod/`)

**Phase 7 — Build & Deployment:**

- SAM CLI commands (`sam build`, `sam deploy`)
- Terraform commands (`terraform plan`, `terraform apply`)
- Docker build and push commands
- CI/CD integration for infrastructure deployment

**Phase 8 — Testing:**

- CloudFormation linting (cfn-lint)
- Terraform validation (`terraform validate`, tflint)
- Docker image scanning
- Infrastructure tests (Terratest, cfn-nag)

---

## CI/CD: GitHub Actions

**Phase 7 — Build & Deployment (additional):**

- Parse all `.github/workflows/*.yml` files
- Extract: `env:` variables at workflow/job/step levels
- Extract: `secrets.*` and `vars.*` references
- Extract: `environment:` keys (deployment environment names)
- Extract: runner labels (`runs-on:`)
- Extract: trigger events (`on:`) and branch filters
- Trace shell scripts invoked by `run:` steps

---

## CI/CD: BitBucket Pipelines

**Phase 7 — Build & Deployment (additional):**

- Parse `bitbucket-pipelines.yml`
- Extract: pipeline branches and triggers
- Extract: deployment environment names
- Extract: runner labels or execution targets per step
- Extract: environment variables in scripts (`$VARNAME`, `${VARNAME}`)
- Extract: secured variables and deployment variables
- Trace shell scripts invoked by pipeline steps
