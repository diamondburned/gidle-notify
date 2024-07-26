CC ?= gcc
PKGCONFIG ?= pkg-config

CFLAGS = $(shell cat compile_flags.txt) $(shell $(PKGCONFIG) --cflags gtk4)
LIBS = $(shell $(PKGCONFIG) --libs gtk4)
GLIB_COMPILE_RESOURCES = $(shell $(PKGCONFIG) --variable=glib_compile_resources gio-2.0)
GLIB_COMPILE_SCHEMAS = $(shell $(PKGCONFIG) --variable=glib_compile_schemas gio-2.0)

TESTS = $(shell find src -name 'test-*.c')
SRCS = $(shell find src \( -name '*.c' -and -not -name 'test-*.c' \))
OBJS = $(SRCS:.c=.o)

%.o: %.c
	$(CC) -c -o "$@" $(CFLAGS) $<

%.test: %.c $(OBJS)
	$(CC) -o "$@" $(OBJS) $(LIBS)

.PHONY: test
test: $(TESTS:.c=.test)
	@for test in $^; do \
		echo "Running $$test"; \
		./$$test; \
	done
