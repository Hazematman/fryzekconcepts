SRC_DIR := notes
BUILD_DIR := build
HTML_DIR := html
PAGE_DIR := pages
SOURCE_DOCS := $(wildcard $(SRC_DIR)/*.md)
PAGE_DOCS := $(wildcard $(PAGE_DIR)/*.md)

META_DOCS=$(patsubst $(SRC_DIR)/%,$(BUILD_DIR)/%,$(SOURCE_DOCS:.md=.meta))
HTML_DOCS=$(patsubst $(SRC_DIR)/%,$(HTML_DIR)/notes/%,$(SOURCE_DOCS:.md=.html))
SOURCE_FILES=$(patsubst $(SRC_DIR)/%,%,$(SOURCE_DOCS:.md=))
PAGE_FILES=$(patsubst $(PAGE_DIR)/%,$(HTML_DIR)/%,$(PAGE_DOCS:.md=.html))

export PLANTUML_LIMIT_SIZE=16384

$(BUILD_DIR)/%.meta: $(SRC_DIR)/%.md
	@mkdir -p $(BUILD_DIR)
	pandoc --write=tools/link_gen.lua $< -o $@

.PRECIOUS: $(META_DOCS)
$(HTML_DIR)/notes/%.html: $(BUILD_DIR)/%.meta $(META_DOCS)
	@mkdir -p $(HTML_DIR)
	@mkdir -p $(HTML_DIR)/notes
	pandoc -s --template=./templates/main.html \
		--lua-filter=./tools/note.lua \
		--filter ./tools/pandoc-plantuml.py \
		$(patsubst $(BUILD_DIR)/%,$(SRC_DIR)/%,$(<:.meta=.md)) \
		--highlight-style=pygments \
		-o $@

$(HTML_DIR)/%.html: $(PAGE_DIR)/%.md
	@mkdir -p $(HTML_DIR)
	pandoc -s --template=./templates/main.html \
		$< \
		--highlight-style=pygments \
		-M main_class="html-main-page" \
		-M main_container="main-container-page" \
		--filter ./tools/pandoc-plantuml.py \
		-o $@

$(HTML_DIR)/feed.xml: $(META_DOCS)
	./tools/rss_gen.py $@

$(HTML_DIR)/graphics_feed.xml: $(META_DOCS)
	./tools/rss_gen.py $@ igalia graphics

$(HTML_DIR)/index.html: $(HTML_DOCS) $(PAGE_FILES) $(HTML_DIR)/feed.xml $(HTML_DIR)/graphics_feed.xml
	touch $(HTML_DIR)/.nojekyll
	pandoc -s --lua-filter=./tools/front_page.lua --template=./templates/main.html main.md \
		--metadata=note_list:"$(SOURCE_FILES)" \
		-o $@

.PHONY: all clean
.DEFAULT_GOAL := all

all: $(HTML_DIR)/index.html

deploy: all
	git subtree push --prefix html origin gh-pages

clean:
	rm -rf build
	find html -name "*.html" -type f -delete
	find html -name "*.xml" -type f -delete
