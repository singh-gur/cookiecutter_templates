# syntax=docker/dockerfile:1
FROM python:{{ cookiecutter.python_version }}-slim

# Install uv (fast Python package manager)
RUN pip install --no-cache-dir uv

# Create app user and dirs
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install build deps for psycopg (removed later)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates gcc libc6-dev && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY pyproject.toml .
COPY .env.example ./.env  # override with real secrets in runtime
COPY {{ cookiecutter.package_name }} ./{{ cookiecutter.package_name }}
COPY docker ./docker

# Resolve and install with uv (creates uv.lock)
RUN uv sync --frozen || uv sync

# Runtime env (can be overridden by compose/env)
ENV ENV=prod \
    LOG_LEVEL=INFO \
    LOG_JSON=true \
    OTEL_SERVICE_NAME={{ cookiecutter.project_slug }} \
    OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4318 \
    OTEL_TRACES_EXPORTER=otlp \
    OTEL_METRICS_EXPORTER=otlp \
    OTEL_LOGS_EXPORTER=otlp

# Expose port
EXPOSE 8000

# Init DB (SQLite) on first run if needed
# Use opentelemetry-instrument to auto-instrument FastAPI/ASGI and logging
CMD ["opentelemetry-instrument", \
     "uv", "run", "uvicorn", "{{ cookiecutter.package_name }}.main:app", \
     "--host", "0.0.0.0", "--port", "8000"]
