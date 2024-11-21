pipx install python-lsp-server
pipx inject python-lsp-server \
	python-lsp-black \
	python-lsp-isort \
	pylsp-mypy \
	--include-deps
