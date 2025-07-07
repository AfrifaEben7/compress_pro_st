#include <stddef.h>
#include <stdint.h>

// C implementation of RLE compression 
size_t rle_compress_c(const int32_t *data, size_t size, int32_t *out) {
    if (size == 0) return 0;
    
    size_t out_index = 0;
    int32_t current_value = data[0];
    uint32_t count = 1;
    
    for (size_t i = 1; i < size; i++) {
        if (data[i] == current_value) {
            count++;
        } else {
            // Store [count, value] pair
            out[out_index++] = count;
            out[out_index++] = current_value;
            
            current_value = data[i];
            count = 1;
        }
    }
    
    // Store final [count, value] pair
    out[out_index++] = count;
    out[out_index++] = current_value;
    
    return out_index;
}

// C implementation of Delta compression 
size_t delta_compress_c(const int32_t *data, size_t size, int32_t *out) {
    if (size == 0) return 0;
    
    // Store first value as-is
    out[0] = data[0];
    
    // Store deltas
    for (size_t i = 1; i < size; i++) {
        out[i] = data[i] - data[i-1];
    }
    
    return size;
}

// C implementation of pattern search 
size_t pattern_search_c(const int32_t *data, size_t size, 
                       const int32_t *pattern, size_t pattern_size,
                       size_t *results, size_t max_results) {
    size_t found = 0;
    
    if (pattern_size == 0 || pattern_size > size) return 0;
    
    for (size_t i = 0; i <= size - pattern_size && found < max_results; i++) {
        // Check if pattern matches at position i
        int match = 1;
        for (size_t j = 0; j < pattern_size; j++) {
            if (data[i + j] != pattern[j]) {
                match = 0;
                break;
            }
        }
        
        if (match) {
            results[found++] = i;
        }
    }
    
    return found;
}
