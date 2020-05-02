#
#  defaults.mk
#
#  Sensible defaults for any Python project.
#
OK_MSG = \x1b[32m ✔\x1b[0m
SHELL=bash

default: test

test-default: format lint mypy unittest
	@echo -e "All tests complete $(OK_MSG)"

format-default: .venv
	@echo -n "==> Checking that code is autoformatted with black..."
	@.venv/bin/black --check --quiet --exclude '(.venv|vendor)' .
	@echo -e "$(OK_MSG)"

lint-default: .venv
	@echo -n "==> Running flake8..."
	@.venv/bin/flake8 --show-source --statistics $(CODE_LOCATIONS) --exclude=.venv
	@echo -e "$(OK_MSG)"

mypy-default: .venv
	@echo -n "==> Type checking..."
	@.venv/bin/mypy --no-error-summary $(CODE_LOCATIONS)
	@echo -e "$(OK_MSG)"

unittest-default: .venv
	@echo "==> Running tests..."
	@PYTHONPATH=. .venv/bin/pytest $(CODE_LOCATIONS) --cov-report term-missing:skip-covered --cov $(CODE_LOCATIONS) --no-cov-on-fail --cov-fail-under=$(COVERAGE_LIMIT) -W ignore::DeprecationWarning -vv

.venv: requirements.txt
	test -d .venv || python3 -m venv .venv
	# build wheels when developing locally
	test -z "$$CI" && .venv/bin/pip install -U pip wheel || true
	.venv/bin/pip install -r requirements.txt
	touch .venv

blacken-default: .venv
	.venv/bin/black --exclude '(.venv|vendor)' .

clean-default:
	rm -rf .venv

%: %-default
	@ true
