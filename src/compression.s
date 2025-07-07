.text
.align 2

// ===============================================
// STUDENT ASSIGNMENT: COMPRESSION ALGORITHMS
// ===============================================
// Implement RLE, Delta compression, and Search algorithms
// Follow AAPCS64 calling conventions
// All functions must preserve callee-saved registers (x19-x28)

// ===============================================
// RLE COMPRESSION
// ===============================================
// Input: 
//   x0 = input array (pointer to int32_t)
//   x1 = input size (number of elements)
//   x2 = output array (pointer to int32_t)
// Output: 
//   x0 = compressed size (number of elements stored)
//
// Algorithm:
//   1. For consecutive identical values, store as [value, count] pairs
//   2. Example: [5,5,5,7,7] -> [5,3,7,2] (value=5, count=3, value=7, count=2)
//   3. Return total number of elements stored in output array
//
.global rle_compress
rle_compress:
    // TODO: Implement RLE compression algorithm
    // 
    // HINTS:
    // - Use x3 for current value, x4 for count, x5 for output index
    // - Don't forget to store the final value/count pair
    // - Handle edge cases (empty input, single element)
    // 
    // Pseudocode:
    // output_index = 0
    // current_value = input[0]
    // count = 1
    // for i = 1 to input_size-1:
    //   if input[i] == current_value:
    //     count++
    //   else:
    //     output[output_index] = current_value
    //     output[output_index+1] = count
    //     output_index += 2
    //     current_value = input[i]
    //     count = 1
    // // Don't forget the last pair!
    // output[output_index] = current_value
    // output[output_index+1] = count
    // return output_index + 2

    // YOUR CODE HERE
    mov x0, #0  // Placeholder - replace with your implementation
    ret

// ===============================================
// DELTA COMPRESSION
// ===============================================
// Input:
//   x0 = input array (pointer to int32_t)
//   x1 = input size (number of elements)
//   x2 = output array (pointer to int32_t)
// Output:
//   x0 = compressed size (number of elements stored)
//
// Algorithm:
//   1. Store first value as 32-bit integer
//   2. For remaining values, store difference from previous value
//   3. Pack two 16-bit deltas into one 32-bit word when possible
//   4. Return total number of 32-bit words used
//
.global delta_compress
delta_compress:
    // TODO: Implement Delta compression algorithm
    //
    // HINTS:
    // - First element: output[0] = input[0]
    // - For i >= 1: delta = input[i] - input[i-1]
    // - Pack deltas as 16-bit values: output[j] = (delta2 << 16) | delta1
    // - Handle cases where delta doesn't fit in 16 bits
    //
    // Pseudocode:
    // output[0] = input[0]
    // output_index = 1
    // for i = 1 to input_size-1:
    //   delta = input[i] - input[i-1]
    //   if delta fits in 16 bits:
    //     store as 16-bit value (pack 2 per 32-bit word)
    //   else:
    //     store as 32-bit value
    // return output_index

    // YOUR CODE HERE
    mov x0, #0  // Placeholder - replace with your implementation
    ret

// ===============================================
// PATTERN SEARCH
// ===============================================
// Input:
//   x0 = input array (pointer to int32_t)
//   x1 = input size (number of elements)
//   x2 = search value (int32_t)
// Output:
//   x0 = number of matches found
//
// Algorithm:
//   1. Iterate through the array
//   2. Count how many elements match the search value
//   3. Return the total count
//
.global search_pattern
search_pattern:
    // TODO: Implement pattern search algorithm
    //
    // HINTS:
    // - Use a loop to iterate through the array
    // - Compare each element with the search value
    // - Keep a counter for matches
    // - Use proper register preservation
    //
    // Pseudocode:
    // match_count = 0
    // for i = 0 to input_size-1:
    //   if input[i] == search_value:
    //     match_count++
    // return match_count

    // YOUR CODE HERE
    mov x0, #0  // Placeholder - replace with your implementation
    ret
