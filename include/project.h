#ifndef PROJECT_H
#define PROJECT_H

#include <stdint.h>
#include <stddef.h>

// Assembly function prototypes (student implementations)
extern size_t rle_compress(const int32_t *data, size_t size, int32_t *out);
extern size_t delta_compress(const int32_t *data, size_t size, int32_t *out);
extern size_t pattern_search(const int32_t *data, size_t size, 
                           const int32_t *pattern, size_t pattern_size,
                           size_t *results, size_t max_results);

// C function prototypes (reference implementations)
extern size_t rle_compress_c(const int32_t *data, size_t size, int32_t *out);
extern size_t delta_compress_c(const int32_t *data, size_t size, int32_t *out);
extern size_t pattern_search_c(const int32_t *data, size_t size,
                             const int32_t *pattern, size_t pattern_size,
                             size_t *results, size_t max_results);

// Utility functions
extern void array_copy(const int32_t *src, int32_t *dest, size_t size);
extern void* allocate_memory(size_t size);
extern void free_memory(void* ptr);
extern void* allocate_buffer(size_t size);
extern void free_buffer(void* ptr);
extern size_t calculate_compression_ratio(size_t original, size_t compressed);
extern void zero_memory(void* ptr, size_t size);

#endif // PROJECT_H
