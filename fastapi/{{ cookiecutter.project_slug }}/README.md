# {{ cookiecutter.project_name }}

{{ cookiecutter.description }}

## Development Setup

1) **Install uv** (if not already installed):
```bash
pipx install uv
```

2) **Install dependencies**:
```bash
uv sync
```

3) **Configure environment**:
```bash
cp .env.example .env
# Edit secrets in .env (JWT_SECRET, DATABASE_URL, etc.)
```

4) **Initialize database**:
```bash
just initdb
```

5) **Run development server**:
```bash
just run
```

Open http://127.0.0.1:8000/docs for Swagger UI.

## Development Commands

This project uses `justfile` for common development tasks:

```bash
just run      # Start development server with auto-reload
just initdb   # Initialize database schema
just test     # Run test suite
```

## Code Quality

```bash
uv run ruff check     # Lint code
uv run ruff format    # Format code
uv run mypy .         # Type checking
```

## Notes

- Logging uses **structlog** (JSON by default). Set `LOG_LEVEL` and `LOG_JSON=false` in `.env` to switch to key-value logfmt.
- ORM is **SQLModel** (on top of SQLAlchemy). Defaults to SQLite; opt into Postgres during cookiecutter prompts.
- Token auth is JWT with `OAuth2PasswordBearer`.


## Docker (with OpenTelemetry)

Build and run with the bundled OpenTelemetry Collector:

```bash
# 1) Copy env and edit secrets
cp .env.example .env

# 2) (Optional) switch to Postgres in .env and set USE_POSTGRES=y during cookiecutter prompts
# DATABASE_URL=postgresql+psycopg://app:app@db:5432/app

# 3) Start services
docker compose up --build
```

- App exposed at http://127.0.0.1:8000
- OTLP endpoint is provided by the Collector at `http://localhost:4318`
- Traces/metrics/logs are exported to the Collector (then printed to collector logs by default).

### View OTEL data
Open another terminal:
```bash
docker compose logs -f otel-collector
```
You should see spans/logs/metrics arriving.

### Production notes
- Replace the logging exporter in `docker/otel-collector-config.yaml` with your backend (e.g., OTLP to Tempo/Jaeger for traces, Prometheus/OTLP for metrics, Loki/OTLP for logs).
- For k8s, mount env and set `OTEL_EXPORTER_OTLP_ENDPOINT` to your collector/agent.
