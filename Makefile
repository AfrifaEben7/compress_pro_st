# Student Assignment Makefile
CC=aarch64-linux-gnu-gcc
AS=aarch64-linux-gnu-gcc
LD=aarch64-linux-gnu-gcc
CFLAGS=-Wall -g
ASFLAGS=-c -Wall -g

# Explicit object file names to avoid conflicts
OBJ=src/main.o src/compression_asm.o src/utils.o src/memory.o src/compression_c.o

all: sigscan decompress

sigscan: $(OBJ)
	$(LD) -o $@ $(OBJ)

decompress: decompress.c
	$(CC) $(CFLAGS) -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -Iinclude -c $< -o $@

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

# Special rules to avoid naming conflicts
src/compression_c.o: src/compression.c
	$(CC) $(CFLAGS) -Iinclude -c $< -o $@

src/compression_asm.o: src/compression.s
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(OBJ) sigscan decompress
	rm -f compressed_output/rle/* compressed_output/delta/* compressed_output/reports/*

test-rle:
	./sigscan data/good_rle_data.csv -rle -stats

test-delta:
	./sigscan data/good_delta_data.csv -delta -stats

test-search:
	./sigscan data/good_rle_data.csv -rle -search "100" -stats

verify-rle:
	./verify_compression.sh data/good_rle_data.csv rle

verify-delta:
	./verify_compression.sh data/good_delta_data.csv delta

test-all: test-rle test-delta test-search

help:
	@echo "Student Assignment Build System"
	@echo "Available targets:"
	@echo "  all          - Build the sigscan program"
	@echo "  clean        - Remove compiled files"
	@echo "  test-rle     - Test RLE compression"
	@echo "  test-delta   - Test Delta compression"
	@echo "  test-search  - Test pattern search"
	@echo "  test-all     - Run all basic tests"
	@echo "  verify-rle   - Verify RLE correctness"
	@echo "  verify-delta - Verify Delta correctness"
	@echo "  help         - Show this help message"

.PHONY: all clean test-rle test-delta test-search test-all verify-rle verify-delta help
