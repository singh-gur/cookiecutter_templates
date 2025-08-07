# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains multiple cookiecutter templates for different project types. Each template is organized in its own directory with a `cookiecutter.json` configuration file and template structure.

**Available Templates:**
- `fastapi/`: Production-ready FastAPI service template with authentication, database integration, and observability

## FastAPI Template

Located in `fastapi/{{ cookiecutter.project_slug }}/`, this template generates FastAPI applications with:

**Architecture:**
- **Core layer**: Configuration, logging, and OpenTelemetry setup in `core/`
- **Database layer**: SQLModel models and session management in `db/`
- **API layer**: FastAPI routes organized by domain in `api/routes/`
- **Security layer**: JWT authentication and password hashing in `security/`

**Key Technologies:**
- FastAPI with automatic API documentation
- SQLModel ORM with SQLite/PostgreSQL support
- structlog for JSON-structured logging  
- OpenTelemetry for distributed tracing
- JWT token-based authentication
- uv for fast Python package management

## Template Usage

Generate a new project from any template:
```bash
cookiecutter path/to/template/directory
```

For FastAPI template:
```bash
cookiecutter fastapi/
```

## FastAPI Template Configuration

Customized through `fastapi/cookiecutter.json`:
- `project_name`: Human-readable project name
- `project_slug`: Directory/package name (snake_case)
- `package_name`: Python package name (defaults to "app")
- `use_postgres`: Toggle between SQLite (n) and PostgreSQL (y)

## Generated Project Commands

Projects created from the FastAPI template use `justfile` for common tasks:
```bash
just run      # Start development server with auto-reload
just initdb   # Initialize database schema
just test     # Run pytest test suite
```

Development workflow:
```bash
uv sync                    # Install/update dependencies
uv run ruff check          # Lint code
uv run ruff format         # Format code
uv run mypy .             # Type checking
```

## Docker & Observability

FastAPI template includes:
- `docker-compose.yml` with app + PostgreSQL + OTEL collector
- OpenTelemetry configuration in `docker/otel-collector-config.yaml`
- Instrumentation for FastAPI, logging, and database queries