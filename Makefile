BUILD_DIR=docs

.PHONY: default
default: clean deps build view
	@echo "# DONE!"

.PHONY: deps
deps:
	pipx install sphinx==5.0
	pipx inject sphinx sphinx-copybutton

.PHONY: build
build:
	@mkdir -p $(BUILD_DIR)
	sphinx-build -E -b html -c ./ site  $(BUILD_DIR)
	touch $(BUILD_DIR)/.nojekyll
	cp site/CNAME $(BUILD_DIR)/CNAME

.PHONY: view
view:
	xdg-open http://localhost:8080/ || open http://localhost:8080 || echo "Failed launching browser"

.PHONY: serve
serve:
	@pkill -f http.server || echo "Could not kill server, probably not running"
	cd $(BUILD_DIR) && screen -d -m "python3 -m http.server 8080"

.PHONY: clean
clean:
	rm -r $(BUILD_DIR) || echo "Cannot remove => That is OK"
