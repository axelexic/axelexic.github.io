# TikZ/LaTeX -> standalone SVG via latex + dvisvgm.

BUILD     ?= build
BORDER    ?= 30pt
FONT_SIZE ?= 18pt

TEX_SOURCES := $(wildcard *.tex)
SVG_TARGETS := $(TEX_SOURCES:.tex=.svg)
PDF_TARGETS := $(TEX_SOURCES:.tex=.pdf)

MAKEFILE_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
AWK_SCRIPT   := $(MAKEFILE_DIR)/../../scripts/tex/article-to-standalone.awk

PDFLATEX := latexmk -pdflua
DVILATEX := latexmk -dvilua
DVISVGM  := dvisvgm

# -outdir keeps root clean. -M -MF generates make-compatible dependency files.
LATEX_FLAGS   := -interaction=nonstopmode -file-line-error -outdir=$(BUILD)
PDFLATEXFLAGS := $(LATEX_FLAGS)
DVILATEXFLAGS := $(LATEX_FLAGS)
DVISVGMFLAGS  := --no-fonts --optimize=all,-remove-clippath --exact-bbox --bbox=papersize --libgs=/opt/homebrew/lib/libgs.dylib

# Fail early if required tools are missing
ifeq (, $(shell command -v $(DVILATEX) 2> /dev/null))
  $(warning "Warning: '$(DVILATEX)' not found in PATH")
endif
ifeq (, $(shell command -v $(DVISVGM) 2> /dev/null))
  $(warning "Warning: '$(DVISVGM)' not found in PATH")
endif

.PHONY: all pdf clean distclean help
.DELETE_ON_ERROR:
.PRECIOUS: $(BUILD)/%-svg.tex $(BUILD)/%-svg.dvi $(BUILD)/%.pdf

all: $(SVG_TARGETS)
pdf: $(PDF_TARGETS)

$(BUILD):
	mkdir -p "$@"

# 1. Preprocess the .tex file for SVG generation
$(BUILD)/%-svg.tex: %.tex | $(BUILD)
	awk -v fontsize=$(FONT_SIZE) -f "$(AWK_SCRIPT)" "$<" > "$@"

# 2. Compile DVI and generate dependency tree (.d file) for included files
$(BUILD)/%-svg.dvi: $(BUILD)/%-svg.tex
	$(DVILATEX) $(DVILATEXFLAGS) -M -MF $(BUILD)/$*-svg.d "$<"

# 3. Convert DVI to SVG
%.svg: $(BUILD)/%-svg.dvi
	$(DVISVGM) $(DVISVGMFLAGS) "$<" -o "$@"

# 4. Compile PDF and generate dependency tree
$(BUILD)/%.pdf: %.tex | $(BUILD)
	$(PDFLATEX) $(PDFLATEXFLAGS) -M -MF $(BUILD)/$*.d "$<"

# Pull PDFs out of the build directory to the root
%.pdf: $(BUILD)/%.pdf
	cp "$<" "$@"

clean:
	rm -rf "$(BUILD)"

distclean: clean
	rm -f $(SVG_TARGETS) $(PDF_TARGETS)

help:
	@echo "make                 Build SVGs for all .tex files"
	@echo "make pdf             Build PDFs for all .tex files"
	@echo "make foo.svg         Build foo.svg from foo.tex"
	@echo "make foo.pdf         Build foo.pdf from foo.tex"
	@echo "make BORDER=10pt     Override injected standalone border"
	@echo "make clean           Remove build directory"
	@echo "make distclean       Remove build directory and all generated SVGs/PDFs"

# Include auto-generated dependencies (Make ignores missing files on the first run)
-include $(TEX_SOURCES:%.tex=$(BUILD)/%.d)
-include $(TEX_SOURCES:%.tex=$(BUILD)/%-svg.d)