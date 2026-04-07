# Cookiecutter Templates

This repository contains reusable `cookiecutter` templates for bootstrapping new Python-based repositories.

Today it includes:

- `fastapi/`: a FastAPI service scaffold with auth, SQLModel, OpenTelemetry, Docker support, and optional Postgres wiring
- `prefect_flow/`: a Prefect flow scaffold with Kubernetes-first deployment defaults and a local example flow

The templates are designed to be rendered locally, inspected, and then used as the starting point for a new repository.

## Requirements

You will need:

- `uv` for running `uvx cookiecutter` and for the generated projects' dependency management
- `just` for using the repo-level helper commands and the generated projects' command shortcuts

Install `uv` if needed:

```bash
pipx install uv
```

Install `just` if needed:

```bash
# Choose the install method appropriate for your machine
# https://github.com/casey/just
```

## Repository Layout

Each top-level template directory contains:

- a `cookiecutter.json` file that defines the prompt values
- a `{{ cookiecutter.project_slug }}/...` tree that becomes the generated project

The repository-level `justfile` provides shortcuts to render and smoke-test the current templates without typing long `cookiecutter` commands by hand.

## Available Templates

### `fastapi`

Generates a FastAPI application scaffold with:

- `uv`-managed Python project layout
- JWT authentication support
- SQLModel-based data layer
- `structlog` logging
- OpenTelemetry dependencies and Docker collector config
- optional Postgres-specific sections in `docker-compose.yml` and `.env.example`
- a minimal test entrypoint via the generated project's `just test`

Current prompt values exposed by `fastapi/cookiecutter.json`:

- `project_name`
- `project_slug`
- `package_name`
- `description`
- `author_name`
- `python_version`
- `use_postgres` with values `y` or `n`

Typical generated project files include:

- `pyproject.toml`
- `justfile`
- `README.md`
- `Dockerfile`
- `docker-compose.yml`
- `.env.example`
- `tests/`
- `{{ package_name }}/...`

### `prefect_flow`

Generates a Prefect project scaffold with:

- `uv`-managed Python project layout
- an example flow module and exported entrypoint
- a `prefect.yaml` configured for a Kubernetes work pool by default
- git-based runtime pull steps in deployment configuration
- a local smoke-test command that runs with Prefect ephemeral mode enabled

Current prompt values exposed by `prefect_flow/cookiecutter.json`:

- `project_name`
- `project_slug`
- `package_name`
- `description`
- `author_name`
- `python_version`
- `repository_url`
- `default_branch`
- `deployment_name`
- `flow_module_name`
- `flow_function_name`
- `work_pool_name`
- `cron_schedule`
- `timezone`

Typical generated project files include:

- `pyproject.toml`
- `prefect.yaml`
- `justfile`
- `README.md`
- `main.py`
- `.gitignore`
- `.prefectignore`
- `{{ package_name }}/flows/...`

## Quick Start

List the templates currently tracked in this repository:

```bash
just list-templates
```

Render a template to a temporary directory:

```bash
just render-fastapi /tmp/rendered_fastapi
just render-prefect-flow /tmp/rendered_prefect
```

Run the basic smoke check for a rendered project:

```bash
just test-fastapi /tmp/rendered_fastapi
just test-prefect-flow /tmp/rendered_prefect
```

Or do both steps at once:

```bash
just check-fastapi
just check-prefect-flow
```

## Preferred Workflow

When changing a template in this repository, the safest workflow is:

1. Edit the template files under `fastapi/` or `prefect_flow/`.
2. Render the updated template into `/tmp/...`.
3. Run the generated project's own commands to confirm it still works.
4. Inspect the rendered output rather than assuming the template change behaved as expected.

For this repo, render-first validation is more reliable than only reading the template source.

## Rendering with Repo Helpers

The root `justfile` exposes repo-level helpers for the supported templates.

### FastAPI helper commands

Render with defaults:

```bash
just render-fastapi /tmp/rendered_fastapi
```

Render with custom values:

```bash
just render-fastapi /tmp/rendered_fastapi my_service service y
```

That positional call maps to:

- `output_dir=/tmp/rendered_fastapi`
- `project_slug=my_service`
- `package_name=service`
- `use_postgres=y`

Smoke-test the rendered project:

```bash
just test-fastapi /tmp/rendered_fastapi my_service
```

Run render + smoke test together:

```bash
just check-fastapi
just check-fastapi /tmp/my_fastapi_check my_service service y
```

### Prefect helper commands

Render with defaults:

```bash
just render-prefect-flow /tmp/rendered_prefect
```

Render with custom values:

```bash
just render-prefect-flow /tmp/rendered_prefect backups_flow backups_flow
```

That positional call maps to:

- `output_dir=/tmp/rendered_prefect`
- `project_slug=backups_flow`
- `package_name=backups_flow`

Smoke-test the rendered project:

```bash
just test-prefect-flow /tmp/rendered_prefect backups_flow
```

Run render + smoke test together:

```bash
just check-prefect-flow
just check-prefect-flow /tmp/my_prefect_check backups_flow backups_flow
```

## Rendering Directly with Cookiecutter

If you want full control over prompt values, use `uvx cookiecutter` directly.

### Render `fastapi`

```bash
uvx cookiecutter /abs/path/to/cookiecutter_templates/fastapi \
  --no-input \
  project_name="My FastAPI Service" \
  project_slug="my_fastapi_service" \
  package_name="app" \
  description="FastAPI + uv + structlog + JWT + SQLModel" \
  author_name="Your Name" \
  python_version="3.11" \
  use_postgres="n" \
  --output-dir /tmp/rendered_fastapi
```

### Render `prefect_flow`

```bash
uvx cookiecutter /abs/path/to/cookiecutter_templates/prefect_flow \
  --no-input \
  project_name="My Prefect Flow" \
  project_slug="my_prefect_flow" \
  package_name="my_prefect_flow" \
  description="Prefect flow scaffold with Kubernetes-first deployment defaults" \
  author_name="Your Name" \
  python_version="3.12" \
  repository_url="https://github.com/your-org/your-repo.git" \
  default_branch="main" \
  deployment_name="default" \
  flow_module_name="example_flow" \
  flow_function_name="run_flow" \
  work_pool_name="kubernetes" \
  cron_schedule="0 2 * * *" \
  timezone="America/New_York" \
  --output-dir /tmp/rendered_prefect
```

## Validating Rendered Projects

### FastAPI validation

After rendering:

```bash
just --justfile /tmp/rendered_fastapi/my_fastapi_service/justfile test
```

If you changed `use_postgres`-conditional files such as `docker-compose.yml` or `.env.example`, validate the branch you actually changed by rendering with matching prompt values.

### Prefect validation

After rendering:

```bash
just --justfile /tmp/rendered_prefect/my_prefect_flow/justfile run-local
```

The generated Prefect `run-local` command clears `PREFECT_API_URL` and enables Prefect ephemeral mode so the example flow does not depend on the current machine's active Prefect profile.

## Template-Specific Notes

### FastAPI notes

- The generated project's source of truth is its own `pyproject.toml`, `justfile`, Docker files, and app package.
- `use_postgres` controls conditional sections in `docker-compose.yml` and `.env.example`.
- The generated project includes OpenTelemetry-related dependencies and local Docker collector wiring.

### Prefect notes

- The generated `prefect.yaml` uses git-based pull steps at runtime rather than baking and pushing an image from this template repo.
- The `repository_url` prompt must point at the real repo that workers should clone when the deployment runs.
- `prefect.yaml` intentionally preserves Prefect's runtime placeholder `{{ clone_step.directory }}` using a Jinja raw block inside the template source. Do not simplify that to plain `{{ ... }}` in the template.

## Helpful Repo Commands

Show available repo helper recipes:

```bash
just --list
```

Show the current repo status:

```bash
just status
```

## Contributing Template Changes

When updating a template:

1. Change the template source under the appropriate top-level directory.
2. Render the template to `/tmp/...`.
3. Run the generated project's own smoke-test command.
4. Update this root `README.md` if the template prompts, defaults, or validation workflow changed.

This repository is small enough that keeping the top-level README aligned with the current templates is worth doing every time the scaffolds change.
