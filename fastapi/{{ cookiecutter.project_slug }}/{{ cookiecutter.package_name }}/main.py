from fastapi import FastAPI
from {{ cookiecutter.package_name }}.core.config import settings
from {{ cookiecutter.package_name }}.core.logging import configure_logging
from {{ cookiecutter.package_name }}.core.otel import setup_otel
from {{ cookiecutter.package_name }}.api.routes import auth, health, users

app = FastAPI(title=settings.APP_NAME)

# Configure structlog + std logging
configure_logging()
setup_otel(app)

# Routers
app.include_router(health.router, prefix="/api")
app.include_router(auth.router, prefix="/api")
app.include_router(users.router, prefix="/api")


@app.get("/")
def root():
    return {"app": settings.APP_NAME, "status": "ok"}
