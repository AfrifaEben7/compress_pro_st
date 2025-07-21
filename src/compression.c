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
            // Store [value, count] pair (fixed order)
            out[out_index++] = current_value;
            out[out_index++] = count;
            
            current_value = data[i];
            count = 1;
        }
    }
    
    // Store final [value, count] pair
    out[out_index++] = current_value;
    out[out_index++] = count;
    
    return out_index;
}

// C implementation of Delta compression 
size_t delta_compress_c(const int32_t *data, size_t size, int32_t *out) {
    if (size == 0) return 0;
    
    // Store first value as 32-bit
    out[0] = data[0];
    size_t bytes_written = 4;
    
    // Cast output to byte pointer for 16-bit delta storage
    int8_t *byte_out = (int8_t*)out;
    int8_t *delta_start = byte_out + 4;  // Start after first 32-bit value
    
    // Store deltas as 16-bit values
    for (size_t i = 1; i < size; i++) {
        int32_t delta = data[i] - data[i-1];
        
        // Check if delta fits in 16-bit range
        if (delta >= -32768 && delta <= 32767) {
            // Store as 16-bit delta
            int16_t delta16 = (int16_t)delta;
            *((int16_t*)(delta_start + (i-1)*2)) = delta16;
            bytes_written += 2;
        } else {
            // Delta too large, fallback to original data
            for (size_t j = 0; j < size; j++) {
                out[j] = data[j];
            }
            return size;  // Return original size in words
        }
    }
    
    // Round up to word boundary and return word count
    size_t word_count = (bytes_written + 3) / 4;
    return word_count;
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
