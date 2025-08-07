from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import Field
import os

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", case_sensitive=False)

    ENV: str = Field(default="dev")
    APP_NAME: str = Field(default="{{ cookiecutter.project_slug }}")
    LOG_LEVEL: str = Field(default="INFO")
    LOG_JSON: bool = Field(default=True)

    # Security
    JWT_SECRET: str = Field(default="change_me")
    JWT_ALGO: str = Field(default="HS256")
    ACCESS_TOKEN_EXPIRE_MINUTES: int = Field(default=60)

    # DB
    USE_POSTGRES: str = Field(default="n")
    DATABASE_URL: str = Field(default="sqlite:///./app.db")  # SQLModel style sqlite

    @property
    def effective_database_url(self) -> str:
        if self.USE_POSTGRES.lower().startswith("y"):
            return self.DATABASE_URL
        return self.DATABASE_URL  # fallback to provided value

settings = Settings()
