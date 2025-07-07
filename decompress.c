#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

// Function prototypes
int decompress_rle(const char* input_file, const char* output_file);
int decompress_delta(const char* input_file, const char* output_file);

int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("Usage: %s <compressed_file> <output_file> <compression_type>\n", argv[0]);
        printf("  compressed_file: Path to compressed binary file\n");
        printf("  output_file: Path to output CSV file\n");
        printf("  compression_type: 'rle' or 'delta'\n");
        return 1;
    }

    const char *input_file = argv[1];
    const char *output_file = argv[2];
    const char *compression_type = argv[3];

    // Check if input file exists
    FILE *test_file = fopen(input_file, "rb");
    if (!test_file) {
        printf("Error: Cannot open input file '%s'\n", input_file);
        return 1;
    }
    fclose(test_file);

    int result = 0;
    if (strcmp(compression_type, "rle") == 0) {
        result = decompress_rle(input_file, output_file);
    } else if (strcmp(compression_type, "delta") == 0) {
        result = decompress_delta(input_file, output_file);
    } else {
        printf("Error: Unknown compression type '%s'. Use 'rle' or 'delta'\n", compression_type);
        return 1;
    }

    if (result == 0) {
        printf("Decompression successful: %s -> %s\n", input_file, output_file);
    } else {
        printf("Decompression failed\n");
    }

    return result;
}

int decompress_rle(const char* input_file, const char* output_file) {
    FILE *input = fopen(input_file, "rb");
    if (!input) {
        printf("Error: Cannot open input file '%s'\n", input_file);
        return 1;
    }

    FILE *output = fopen(output_file, "w");
    if (!output) {
        printf("Error: Cannot create output file '%s'\n", output_file);
        fclose(input);
        return 1;
    }

    // Write CSV header to match original format
    fprintf(output, "timestamp,signal_value\n");

    // Read RLE compressed data
    // Format: [count][value][count][value]...
    // Each count and value is stored as 4-byte integers
    uint32_t count, value;
    int timestamp = 0;

    while (fread(&count, sizeof(uint32_t), 1, input) == 1) {
        if (fread(&value, sizeof(uint32_t), 1, input) != 1) {
            printf("Error: Incomplete RLE data\n");
            fclose(input);
            fclose(output);
            return 1;
        }

        // Write the value 'count' times with timestamps
        for (uint32_t i = 0; i < count; i++) {
            fprintf(output, "%d,%u\n", timestamp++, value);
        }
    }

    fclose(input);
    fclose(output);
    return 0;
}

int decompress_delta(const char* input_file, const char* output_file) {
    FILE *input = fopen(input_file, "rb");
    if (!input) {
        printf("Error: Cannot open input file '%s'\n", input_file);
        return 1;
    }

    FILE *output = fopen(output_file, "w");
    if (!output) {
        printf("Error: Cannot create output file '%s'\n", output_file);
        fclose(input);
        return 1;
    }

    // Write CSV header to match original format
    fprintf(output, "timestamp,signal_value\n");

    // Read Delta compressed data
    // Format: [first_value][delta1][delta2]...
    // Each value is stored as 4-byte signed integer
    int32_t first_value, delta;
    
    // Read first value
    if (fread(&first_value, sizeof(int32_t), 1, input) != 1) {
        printf("Error: Cannot read first value\n");
        fclose(input);
        fclose(output);
        return 1;
    }

    // Write first value with timestamp
    fprintf(output, "0,%d\n", first_value);
    
    int32_t current_value = first_value;
    int timestamp = 1;
    
    // Read and apply deltas
    while (fread(&delta, sizeof(int32_t), 1, input) == 1) {
        current_value += delta;
        fprintf(output, "%d,%d\n", timestamp++, current_value);
    }

    fclose(input);
    fclose(output);
    return 0;
}
