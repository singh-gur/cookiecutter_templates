from contextlib import contextmanager
from sqlmodel import create_engine, Session
from {{ cookiecutter.package_name }}.core.config import settings
from {{ cookiecutter.package_name }}.db.models import SQLModel, User  # ensure model import so metadata is built

engine = create_engine(settings.effective_database_url, echo=False)

def init_db():
    SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session
