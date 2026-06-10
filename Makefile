# Export Markdown posts to standalone TeX files.

POSTS_DIR ?= _posts
TEX_DIR ?= _tex
RUBY ?= ruby
EXPORTER ?= scripts/export_post_to_tex.rb

POST_NAME := $(or $(POST),$(FILE),$(NAME))

.PHONY: help tex tex-all

help:
	@printf '%s\n' \
		'Usage:' \
		'  make tex FILE=2020-06-08-LatticesBasicDefinitions' \
		'  make tex POST=2020-06-08-LatticesBasicDefinitions' \
		'  make tex-all' \
		'' \
		'Variables:' \
		'  POSTS_DIR=_posts' \
		'  TEX_DIR=_tex' \
		'  RUBY=ruby'

tex:
	@if [ -z "$(POST_NAME)" ]; then \
		printf '%s\n' 'Usage: make tex FILE=2020-06-08-LatticesBasicDefinitions'; \
		exit 2; \
	fi
	@if [ ! -f "$(POSTS_DIR)/$(POST_NAME).md" ]; then \
		printf '%s\n' "Post not found: $(POSTS_DIR)/$(POST_NAME).md"; \
		exit 1; \
	fi
	@command -v pandoc >/dev/null || { printf '%s\n' 'pandoc is required but was not found in PATH'; exit 1; }
	@mkdir -p "$(TEX_DIR)"
	$(RUBY) "$(EXPORTER)" "$(POSTS_DIR)/$(POST_NAME).md" --output "$(TEX_DIR)/$(POST_NAME).tex"

tex-all:
	@command -v pandoc >/dev/null || { printf '%s\n' 'pandoc is required but was not found in PATH'; exit 1; }
	@mkdir -p "$(TEX_DIR)"
	$(RUBY) "$(EXPORTER)" "$(POSTS_DIR)" --output "$(TEX_DIR)"
