# TikZ/LaTeX -> standalone SVG via latex + dvisvgm.
#
# Usage:
#   make                    # builds LatticeBasic.svg from LatticeBasic.tex
#   make MAIN=foo           # builds foo.svg from foo.tex
#   make foo.svg            # builds one specific SVG
#   make BORDER=10pt        # changes the standalone border injected into temp source
#   make clean              # removes generated build files
#
# The source is not edited. A patched copy is written to build/ that:
#   1. removes the preview package, which caused "No pages of output";
#   2. adds standalone's border option;
#   3. injects PGF's dvisvgm backend before TikZ is loaded.

MAIN     ?= LatticeBasic
BUILD    ?= build
BORDER   ?= 30pt

LATEX    ?= latex
DVISVGM  ?= dvisvgm

LATEXFLAGS   ?= -interaction=nonstopmode -halt-on-error
DVISVGMFLAGS ?= --no-fonts --exact-bbox --bbox=papersize

.PHONY: all check check-latex check-dvisvgm clean distclean rebuild help
.DELETE_ON_ERROR:
.PRECIOUS: $(BUILD)/%-svg.tex $(BUILD)/%-svg.dvi
.SECONDARY: $(BUILD)/%-svg.tex $(BUILD)/%-svg.dvi

all: $(MAIN).svg

check: check-latex check-dvisvgm

check-latex:
	@command -v $(LATEX) >/dev/null 2>&1 || { echo "error: '$(LATEX)' not found" >&2; exit 1; }

check-dvisvgm:
	@command -v $(DVISVGM) >/dev/null 2>&1 || { echo "error: '$(DVISVGM)' not found" >&2; exit 1; }

$(BUILD):
	mkdir -p "$@"
	cp -r *.tikz "$@"

$(BUILD)/%-svg.tex: %.tex %.tikz | $(BUILD)
	@awk -v border="$(BORDER)" '\
	  /\\usepackage(\[[^]]*\])?\{preview\}/ { next } \
	  /\\setlength\\PreviewBorder/ { next } \
	  /\\PreviewEnvironment\{tikzpicture\}/ { next } \
	  /\\def\\pgfsysdriver/ { if (!driver_done) print; driver_done=1; next } \
	  /\\documentclass/ { \
	    line=$$0; \
	    if (line ~ /\{standalone\}/ && line !~ /border[[:space:]]*=/) { \
	      if (line ~ /\\documentclass\[[^]]*\]/) sub(/\]/, ",border=" border "]", line); \
	      else sub(/\\documentclass/, "\\\\documentclass[border=" border "]", line); \
	    } \
	    print line; \
	    if (!driver_done) { print "\\def\\pgfsysdriver{pgfsys-dvisvgm.def}"; driver_done=1; } \
	    next; \
	  } \
	  { print } \
	' "$<" > "$@"

$(BUILD)/%-svg.dvi: $(BUILD)/%-svg.tex | check-latex
	cd "$(BUILD)" && $(LATEX) $(LATEXFLAGS) "$(notdir $<)"

%.svg: $(BUILD)/%-svg.dvi | check-dvisvgm
	$(DVISVGM) $(DVISVGMFLAGS) "$<" -o "$@"

rebuild: clean all

clean:
	rm -rf "$(BUILD)"
	rm -rf *.aux *.fdb_latexmk *.fls *.log *.synctex.gz *.bbl *.pdf

# Removes generated SVGs too.
distclean: clean
	rm -f "$(MAIN).svg"

help:
	@echo "make                  Build $(MAIN).svg from $(MAIN).tex"
	@echo "make MAIN=foo        Build foo.svg from foo.tex"
	@echo "make foo.svg         Build foo.svg from foo.tex"
	@echo "make BORDER=10pt     Override injected standalone border"
	@echo "make clean           Remove build intermediates"
	@echo "make distclean       Remove build intermediates and $(MAIN).svg"
