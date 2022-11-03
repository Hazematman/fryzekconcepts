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

$(BUILD_DIR)/%.meta: $(SRC_DIR)/%.md
	@mkdir -p $(BUILD_DIR)
	pandoc --write=tools/link_gen.lua $< -o $@

.PRECIOUS: $(META_DOCS)
$(HTML_DIR)/notes/%.html: $(BUILD_DIR)/%.meta $(META_DOCS)
	@mkdir -p $(HTML_DIR)
	@mkdir -p $(HTML_DIR)/notes
	pandoc -s --template=./templates/main.html \
		--lua-filter=./tools/note.lua \
		$(patsubst $(BUILD_DIR)/%,$(SRC_DIR)/%,$(<:.meta=.md)) \
		--highlight-style=pygments \
		-o $@

$(HTML_DIR)/%.html: $(PAGE_DIR)/%.md
	@mkdir -p $(HTML_DIR)
	pandoc -s --template=./templates/main.html \
		$< \
		--highlight-style=pygments \
		-o $@

$(HTML_DIR)/index.html: $(HTML_DOCS) $(PAGE_FILES)
	touch $(HTML_DIR)/.nojekyll
	ln -sf ../assets -t $(HTML_DIR)
	pandoc -s --lua-filter=./tools/front_page.lua --template=./templates/main.html main.md \
		--metadata=note_list:"$(SOURCE_FILES)" \
		-o $@

.PHONY: all clean

all: $(HTML_DIR)/index.html

clean:
	rm -r build
	rm -r html
