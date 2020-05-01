.PHONY: test lint black mypy

default: lint black mypy test

test: .venv
	@echo '==> Running test suite...'
	@.venv/bin/pytest --cov=.

lint: .venv
	@echo '==> Checking code style...'
	@.venv/bin/flake8 *.py

black: .venv
	@echo '==> Checking formatting...'
	@.venv/bin/black --quiet --check *.py

mypy: .venv
	@echo '==> Checking types...'
	@.venv/bin/mypy --no-error-summary *.py

.venv: requirements.txt
	@echo '==> Setting up virtual environment...'
	test -d .venv || python3 -m venv .venv
	.venv/bin/pip install -r requirements.txt
	touch $@
