.DEFAULT_GOAL := help

.PHONY: help deps html serve clean

help:
	@echo "safl.dk docs:"
	@echo "  deps    pipx install ./tooling  (provides safldk-docs-{serve,build-html})"
	@echo "  html    safldk-docs-build-html  -> _build/html/"
	@echo "  serve   safldk-docs-serve       (live rebuild on http://localhost:8000)"
	@echo "  clean   remove _build/"

deps:
	pipx install ./tooling

html:
	safldk-docs-build-html

serve:
	safldk-docs-serve

clean:
	rm -rf _build
