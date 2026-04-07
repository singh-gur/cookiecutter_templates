# Repository Notes

- This repo contains cookiecutter template sources only. Top-level template directories are currently `fastapi/` and `prefect_flow/`.
- There is no CI workflow or repo-level automated test harness. Validate changes by rendering the template you touched.
- The root `justfile` is the main repo-level helper entrypoint for rendering and smoke-testing templates.

# Source Of Truth

- Template prompts live in each template's `cookiecutter.json`.
- The generated project structure and commands live under `{{ cookiecutter.project_slug }}/...` inside each template directory.
- Trust executable files over template READMEs when they differ: `justfile`, `pyproject.toml`, `prefect.yaml`, Docker/config files.

# Validation Workflow

- Preferred render command:
  ```bash
  uvx cookiecutter /abs/path/to/<template_dir> --no-input ... --output-dir /tmp/<render_dir>
  ```
- Preferred repo helpers:
  ```bash
  just render-fastapi /tmp/<dir>
  just test-fastapi /tmp/<dir>
  just render-prefect-flow /tmp/<dir>
  just test-prefect-flow /tmp/<dir>
  ```
- Use `just check-fastapi` or `just check-prefect-flow` for a one-command render + smoke test.
- Always render into `/tmp/...` before concluding a template change is correct.
- After rendering, verify the generated project with that template's own commands instead of inspecting only the template source.

# Template-Specific Checks

- `prefect_flow/`:
  - Render first, then run `just run-local` inside the rendered project.
  - `prefect.yaml` intentionally contains a raw Jinja escape for Prefect's runtime placeholder `{{ clone_step.directory }}`. Do not replace it with plain `{{ ... }}` or cookiecutter rendering will fail.
  - The generated `run-local` command must keep `PREFECT_API_URL='' PREFECT_SERVER_ALLOW_EPHEMERAL_MODE=true` so local smoke tests do not depend on the operator's active Prefect profile.
- `fastapi/`:
  - Render first, then use the generated project's `just test` for a basic smoke test.
  - `use_postgres` affects conditional sections in `docker-compose.yml` and `.env.example`; test whichever branch you edit by rendering with matching prompt values.

# Repo Workflow Gotchas

- When adding templated files that must preserve literal `{{ ... }}` for downstream tools, escape them with Jinja raw blocks so cookiecutter does not evaluate them.
