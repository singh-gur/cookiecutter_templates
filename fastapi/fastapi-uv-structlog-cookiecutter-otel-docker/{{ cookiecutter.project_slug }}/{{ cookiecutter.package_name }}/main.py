from fastapi import FastAPI
from .core.config import settings
from .core.logging import configure_logging
from .core.otel import setup_otel
from .api.routes import auth, health, users

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
