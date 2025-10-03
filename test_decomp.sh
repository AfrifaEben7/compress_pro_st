#!/bin/bash

# Decompression Test Script
# Tests the decompression functionality for both RLE and Delta compression

echo "=== Decompression Test Suite ==="
echo ""

# Check if required binaries exist
if [ ! -x "./sigscan" ]; then
    echo "Error: sigscan binary not found. Please run 'make' first."
    exit 1
fi

if [ ! -x "./decompress" ]; then
    echo "Error: decompress binary not found. Please compile decompress.c first."
    exit 1
fi

# Create test directory
TEST_DIR="test_decomp_output"
mkdir -p "$TEST_DIR"

echo "Test directory: $TEST_DIR"
echo ""

# Test RLE decompression
echo "=== Testing RLE Decompression ==="
if [ -f "data/best_rle_data.csv" ]; then
    echo "1. Compressing with RLE..."
    ./sigscan data/best_rle_data.csv -rle -stats
    
    if [ -f "compressed_output/rle/best_rle_data_rle.bin" ]; then
        echo "2. Decompressing RLE file..."
        ./decompress compressed_output/rle/best_rle_data_rle.bin "$TEST_DIR/rle_decompressed.csv" rle
        
        if [ -f "$TEST_DIR/rle_decompressed.csv" ]; then
            echo "3. Comparing files..."
            if cmp -s data/best_rle_data.csv "$TEST_DIR/rle_decompressed.csv"; then
                echo "RLE decompression test PASSED"
            else
                echo "RLE decompression test FAILED - files don't match"
                echo "First few differences:"
                diff data/best_rle_data.csv "$TEST_DIR/rle_decompressed.csv" | head -10
            fi
        else
            echo "RLE decompression test FAILED - decompressed file not created"
        fi
    else
        echo "RLE compression failed - compressed file not found"
    fi
else
    echo "Skipping RLE test - data/best_rle_data.csv not found"
fi

echo ""

# Test Delta decompression
echo "=== Testing Delta Decompression ==="
if [ -f "data/best_delta_data.csv" ]; then
    echo "1. Compressing with Delta..."
    ./sigscan data/best_delta_data.csv -delta -stats
    
    if [ -f "compressed_output/delta/best_delta_data_delta.bin" ]; then
        echo "2. Decompressing Delta file..."
        ./decompress compressed_output/delta/best_delta_data_delta.bin "$TEST_DIR/delta_decompressed.csv" delta
        
        if [ -f "$TEST_DIR/delta_decompressed.csv" ]; then
            echo "3. Comparing files..."
            if cmp -s data/best_delta_data.csv "$TEST_DIR/delta_decompressed.csv"; then
                echo "Delta decompression test PASSED"
            else
                echo "Delta decompression test FAILED - files don't match"
                echo "First few differences:"
                diff data/best_delta_data.csv "$TEST_DIR/delta_decompressed.csv" | head -10
            fi
        else
            echo "Delta decompression test FAILED - decompressed file not created"
        fi
    else
        echo "Delta compression failed - compressed file not found"
    fi
else
    echo "Skipping Delta test - data/best_delta_data.csv not found"
fi

echo ""

# Test with sample data if available
echo "=== Testing with Sample Data ==="
if [ -f "data/sample_data.csv" ]; then
    echo "Testing RLE with sample data..."
    ./sigscan data/sample_data.csv -rle -stats
    
    if [ -f "compressed_output/rle/sample_data_rle.bin" ]; then
        ./decompress compressed_output/rle/sample_data_rle.bin "$TEST_DIR/sample_rle_decompressed.csv" rle
        
        if cmp -s data/sample_data.csv "$TEST_DIR/sample_rle_decompressed.csv"; then
            echo "Sample RLE test PASSED"
        else
            echo "Sample RLE test FAILED"
        fi
    fi
    
    echo "Testing Delta with sample data..."
    ./sigscan data/sample_data.csv -delta -stats
    
    if [ -f "compressed_output/delta/sample_data_delta.bin" ]; then
        ./decompress compressed_output/delta/sample_data_delta.bin "$TEST_DIR/sample_delta_decompressed.csv" delta
        
        if cmp -s data/sample_data.csv "$TEST_DIR/sample_delta_decompressed.csv"; then
            echo "Sample Delta test PASSED"
        else
            echo "Sample Delta test FAILED"
        fi
    fi
else
    echo "Skipping sample data test - data/sample_data.csv not found"
fi

echo ""
echo "=== Test Complete ==="
echo "Test output files saved in: $TEST_DIR/"
echo ""
