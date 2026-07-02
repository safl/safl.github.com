.DEFAULT_GOAL := help

# Thin convenience wrapper: the real build tooling lives in docs/Makefile
# (which drives the safldk-docs pipx package). These targets just delegate,
# so `make serve` / `make html` work from the repo root too.
.PHONY: help deps html serve clean

help:
	@$(MAKE) -C docs help

deps html serve clean:
	@$(MAKE) -C docs $@
