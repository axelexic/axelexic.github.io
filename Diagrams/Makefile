# 1. Find all subdirectories (at any depth) that contain a Makefile.
#    -mindepth 2 prevents 'find' from matching this top-level Makefile.
SUBDIRS := $(dir $(shell find . -mindepth 2 -type f -name Makefile))

# 2. Mark our targets and subdirectories as .PHONY so Make knows they
#    are commands, not files or folders it should check timestamps for.
.PHONY: all clean distclean pdf $(SUBDIRS)

# 3. Default target: simply running `make` will build all subdirectories
all: $(SUBDIRS)

# 4. The rule that actually executes make in each subdirectory.
#    Using $(MAKE) instead of 'make' is crucial here—it allows flags like
#    parallel execution (make -j4) to be passed down correctly.
$(SUBDIRS):
	$(MAKE) -C $@

# 5. Forwarding standard rules:
#    If you run `make clean` at the top level, this loop ensures
#    `make clean` is called inside every subdirectory.
clean distclean:
	@for dir in $(SUBDIRS); do \
		echo "--> Running make $@ in $$dir"; \
		$(MAKE) -C $$dir $@ || exit 1; \
	done