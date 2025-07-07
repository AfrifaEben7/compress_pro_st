// compression.s - RLE and Delta encoding for ARM64
// Student Implementation File
//
// INSTRUCTIONS:
// Replace the C function calls below with your own ARM64 assembly implementations
// The C versions are provided so you can build and test immediately
// Your goal is to implement the same functionality in ARM64 assembly

    .text
    .extern rle_compress_c
    .extern delta_compress_c
    .extern pattern_search_c
    
    .global rle_compress
    .type rle_compress, %function

// size_t rle_compress(const int32_t *data, size_t size, int32_t *out)
// Input: x0 = input array pointer, x1 = input size, x2 = output array pointer
// Output: x0 = compressed size (number of elements)
//
// Algorithm: Store consecutive identical values as [count, value] pairs
// Example: [100,100,100,75,75] → [3,100,2,75]
//
// TODO: Replace this C function call with your ARM64 assembly implementation
rle_compress:
    // TEMPORARY: Call C version - replace with your assembly implementation
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    bl rle_compress_c
    
    ldp x29, x30, [sp], #16
    ret

    .global delta_compress
    .type delta_compress, %function

// size_t delta_compress(const int32_t *data, size_t size, int32_t *out)
// Input: x0 = input array pointer, x1 = input size, x2 = output array pointer
// Output: x0 = compressed size (number of elements)
//
// Algorithm: Store first value, then differences between consecutive values
// Example: [1000,1001,1002,1003] → [1000,1,1,1]
//
// TODO: Replace this C function call with your ARM64 assembly implementation
delta_compress:
    // TEMPORARY: Call C version - replace with your assembly implementation
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    bl delta_compress_c
    
    ldp x29, x30, [sp], #16
    ret

    .global pattern_search
    .type pattern_search, %function

// size_t pattern_search(const int32_t *data, size_t size,
//                      const int32_t *pattern, size_t pattern_size,
//                      size_t *results, size_t max_results)
// Input: x0 = data array, x1 = data size, x2 = pattern array, x3 = pattern size
//        x4 = results array, x5 = max results
// Output: x0 = number of matches found
//
// Algorithm: Find all occurrences of pattern in data
// For single value search, count how many elements match the pattern value
//
// TODO: Replace this C function call with your ARM64 assembly implementation
pattern_search:
    // TEMPORARY: Call C version - replace with your assembly implementation
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Parameters are already set up correctly for C function
    bl pattern_search_c
    
    ldp x29, x30, [sp], #16
    ret
