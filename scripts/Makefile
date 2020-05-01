.PHONY: test lint black

test: black lint .venv
	@echo '==> Running test suite...'
	@.venv/bin/pytest

lint: .venv
	@echo '==> Checking code style...'
	@.venv/bin/flake8 *.py

black: .venv
	@echo '==> Checking formatting...'
	@.venv/bin/black --quiet --check *.py

.venv: requirements.txt
	@echo '==> Setting up virtual environment...'
	test -d .venv || python3 -m venv .venv
	.venv/bin/pip install -r requirements.txt
	touch $@
