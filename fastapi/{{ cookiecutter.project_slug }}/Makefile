run:
	uv run uvicorn {{ cookiecutter.package_name }}.main:app --reload

initdb:
	uv run python -c "from {{ cookiecutter.package_name }}.db.session import init_db; init_db()"

test:
	uv run pytest -q
