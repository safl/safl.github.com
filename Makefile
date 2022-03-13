BUILD_DIR=docs

.PHONY: default
default: clean reqs build view
	@echo "# DONE!"

.PHONY: reqs
reqs:
	pip3 install -r dev-requirements.txt --user

.PHONY: build
build:
	@mkdir -p $(BUILD_DIR)
	sphinx-build -E -b html -c ./ site  $(BUILD_DIR)
	touch $(BUILD_DIR)/.nojekyll
	echo -n "safl.dk" >> $(BUILD_DIR)/CNAME

.PHONY: view
view:
	#xdg-open $(BUILD_DIR)/html/index.html
	xdg-open http://localhost:8080/

.PHONY: serve
serve:
	cd $(BUILD_DIR) && python3 -m http.server 8080

.PHONY: clean
clean:
	@rm -r $(BUILD_DIR) || echo "Cannot remove => That is OK"
