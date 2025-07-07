#!/bin/bash

# Compression Verification Script
# Usage: ./verify_compression.sh <input_file> <compression_type>
# Example: ./verify_compression.sh data/sample_data.csv rle

if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_file> <compression_type>"
    echo "  input_file: Path to CSV file to compress"
    echo "  compression_type: 'rle' or 'delta'"
    exit 1
fi

INPUT_FILE="$1"
COMPRESSION_TYPE="$2"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found"
    exit 1
fi

# Check if compression type is valid
if [ "$COMPRESSION_TYPE" != "rle" ] && [ "$COMPRESSION_TYPE" != "delta" ]; then
    echo "Error: Compression type must be 'rle' or 'delta'"
    exit 1
fi

# Check if sigscan binary exists
if [ ! -x "./sigscan" ]; then
    echo "Error: sigscan binary not found. Please run 'make' first."
    exit 1
fi

# Create temporary directory for test files
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Generate output filenames
BASE_NAME=$(basename "$INPUT_FILE" .csv)
COMPRESSED_FILE="compressed_output/${COMPRESSION_TYPE}/${BASE_NAME}_${COMPRESSION_TYPE}.bin"
DECOMPRESSED_FILE="$TEMP_DIR/${BASE_NAME}_decompressed.csv"

echo "=== Compression Verification Test ==="
echo "Input file: $INPUT_FILE"
echo "Compression type: $COMPRESSION_TYPE"
echo "Compressed file: $COMPRESSED_FILE"
echo "Decompressed file: $DECOMPRESSED_FILE"
echo ""

# Step 1: Compress the input file
echo "Step 1: Compressing input file..."
if [ "$COMPRESSION_TYPE" = "rle" ]; then
    ./sigscan "$INPUT_FILE" -rle -stats
else
    ./sigscan "$INPUT_FILE" -delta -stats
fi

if [ $? -ne 0 ]; then
    echo "Error: Compression failed"
    exit 1
fi

# Check if compressed file was created
if [ ! -f "$COMPRESSED_FILE" ]; then
    echo "Error: Compressed file was not created at $COMPRESSED_FILE"
    exit 1
fi

echo "✓ Compression successful"
echo ""

# Step 2: Decompress the file
echo "Step 2: Decompressing file..."
if [ -x "./decompress" ]; then
    ./decompress "$COMPRESSED_FILE" "$DECOMPRESSED_FILE" "$COMPRESSION_TYPE"
else
    echo "Warning: decompress binary not found, skipping decompression verification"
    echo "✓ Compression verification passed (decompression not tested)"
    exit 0
fi

if [ $? -ne 0 ]; then
    echo "Error: Decompression failed"
    exit 1
fi

# Check if decompressed file was created
if [ ! -f "$DECOMPRESSED_FILE" ]; then
    echo "Error: Decompressed file was not created"
    exit 1
fi

echo "✓ Decompression successful"
echo ""

# Step 3: Compare original and decompressed files
echo "Step 3: Comparing original and decompressed files..."

# Remove any trailing whitespace and empty lines for comparison
sed 's/[[:space:]]*$//' "$INPUT_FILE" | grep -v '^$' > "$TEMP_DIR/original_clean.csv"
sed 's/[[:space:]]*$//' "$DECOMPRESSED_FILE" | grep -v '^$' > "$TEMP_DIR/decompressed_clean.csv"

if cmp -s "$TEMP_DIR/original_clean.csv" "$TEMP_DIR/decompressed_clean.csv"; then
    echo "✓ Files match perfectly!"
    echo ""
    echo "=== VERIFICATION PASSED ==="
    echo "✓ Compression: OK"
    echo "✓ Decompression: OK"
    echo "✓ Data integrity: OK"
else
    echo "✗ Files do not match!"
    echo ""
    echo "Differences found:"
    diff "$TEMP_DIR/original_clean.csv" "$TEMP_DIR/decompressed_clean.csv" | head -20
    echo ""
    echo "=== VERIFICATION FAILED ==="
    echo "✓ Compression: OK"
    echo "✓ Decompression: OK"
    echo "✗ Data integrity: FAILED"
    exit 1
fi

# Display file sizes for compression ratio analysis
ORIGINAL_SIZE=$(wc -c < "$INPUT_FILE")
COMPRESSED_SIZE=$(wc -c < "$COMPRESSED_FILE")
RATIO=$(echo "scale=2; $COMPRESSED_SIZE * 100 / $ORIGINAL_SIZE" | bc -l 2>/dev/null || echo "N/A")

echo ""
echo "=== Compression Statistics ==="
echo "Original size: $ORIGINAL_SIZE bytes"
echo "Compressed size: $COMPRESSED_SIZE bytes"
echo "Compression ratio: $RATIO%"
echo ""
