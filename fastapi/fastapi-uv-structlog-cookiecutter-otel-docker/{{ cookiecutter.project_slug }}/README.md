# { cookiecutter.project_name }

{ cookiecutter.description }

## Quickstart

1) **Install tools** (macOS/Linux shown):  
```bash
pipx install cookiecutter
pipx install uv
```
2) **Generate a new project** from this template:
```bash
cookiecutter path/to/this/template
```
3) **Enter the project** and install deps with `uv`:
```bash
cd { '{ cookiecutter.project_slug }' }
uv sync
```
4) **Configure environment**:
```bash
cp .env.example .env
# edit secrets in .env (JWT_SECRET, DB URL, etc.)
```
5) **Run**:
```bash
uv run uvicorn { '{ cookiecutter.package_name }' }.main:app --reload
```

Open http://127.0.0.1:8000/docs for Swagger UI.

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
