from httpx import AsyncClient
from {{ cookiecutter.package_name }}.main import app

import pytest

@pytest.mark.anyio
async def test_ping():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        resp = await ac.get("/api/ping")
    assert resp.status_code == 200
    assert resp.json()["ping"] == "pong"
