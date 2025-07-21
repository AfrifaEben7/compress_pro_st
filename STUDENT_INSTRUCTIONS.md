# Signal Compression Assignment

## Overview
Implement RLE (Run-Length Encoding), Delta compression, and Pattern Search algorithms in ARM64 assembly language.

## Learning Objectives
- Practice ARM64 assembly programming
- Understand AAPCS64 calling conventions
- Implement data compression algorithms
- Implement search algorithms
- Work with memory addressing and data manipulation

## What You Need to Implement

### 1. RLE Compression (`rle_compress`)
**Location**: `src/compression.s`
**Function Signature**: 
```assembly
// Input: x0 = input array, x1 = input size, x2 = output array
// Output: x0 = compressed size (number of elements)
```

**Algorithm**: Store consecutive identical values as [value, count] pairs
- Example: `[100,100,100,75,75]` → `[100,3,75,2]`
- This means: value=100 appears 3 times, value=75 appears 2 times

### 2. Delta Compression (`delta_compress`)
**Location**: `src/compression.s`
**Function Signature**:
```assembly
// Input: x0 = input array, x1 = input size, x2 = output array  
// Output: x0 = compressed size (number of elements)
```

**Algorithm**: Store first value, then differences between consecutive values
- Example: `[1000,1001,1002,1003]` → `[1000,1,1,1]`
- First value: 1000, then deltas: +1, +1, +1

### 3. Pattern Search (`search_pattern`)
**Location**: `src/compression.s`
**Function Signature**:
```assembly
// Input: x0 = input array, x1 = input size, x2 = search value
// Output: x0 = number of matches found
```

**Algorithm**: Count how many elements in the array match the search value
- Example: Search for 75 in `[100,100,75,75,50]` → returns 2

## Test Data Provided

### For RLE Testing:
- **File**: `data/good_rle_data.csv`
- **Content**: Long runs of identical values
- **Expected**: ~98% compression ratio

### For Delta Testing:
- **File**: `data/good_delta_data.csv` 
- **Content**: Sequentially increasing values
- **Expected**: ~50% compression ratio

### For Search Testing:
- **File**: Any data file
- **Usage**: `./sigscan data/good_rle_data.csv -rle -search "100" -stats`
- **Expected**: Reports how many times the value appears

## Building and Testing

### Build Your Implementation:
```bash
make clean
make
```

### Test RLE Compression:
```bash
./sigscan data/good_rle_data.csv -rle -stats
```

### Test Delta Compression:
```bash
./sigscan data/good_delta_data.csv -delta -stats
```

### Test Pattern Search:
```bash
./sigscan data/good_rle_data.csv -rle -search "100" -stats
./sigscan data/good_delta_data.csv -delta -search "1250" -stats
```

### Verify Correctness:
```bash
./verify_compression.sh data/good_rle_data.csv rle
./verify_compression.sh data/good_delta_data.csv delta
```

## Expected Results

### RLE Compression:
- Input: 500 values, 2000 bytes
- Output: ~50 bytes (98% compression)
- Algorithm should identify long runs of identical values

### Delta Compression:
- Input: 500 values, 2000 bytes  
- Output: ~1000 bytes (50% compression)
- Algorithm should store small differences efficiently

### Pattern Search:
- Should find and count all occurrences of the search value
- Example: Searching for "100" in RLE test data should find many matches

## ARM64 Assembly Reference

### Function Template:
```assembly
function_name:
    // Preserve callee-saved registers
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    stp x19, x20, [sp, #-16]!
    
    // Your algorithm here
    
    // Restore registers
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
```

### Memory Operations:
```assembly
ldr w5, [x0, x4, lsl #2]    // Load 32-bit word: w5 = array[index]
str w5, [x2, x3, lsl #2]    // Store 32-bit word: output[index] = w5
ldrh w5, [x0, x4, lsl #1]   // Load 16-bit halfword
strh w5, [x2, x3, lsl #1]   // Store 16-bit halfword
```

### Comparison and Branching:
```assembly
cmp x1, x2          // Compare x1 with x2
b.eq .label         // Branch if equal
b.ne .label         // Branch if not equal
b.lt .label         // Branch if less than
b.ge .label         // Branch if greater than or equal
```

### Loop Example:
```assembly
mov x3, #0          // Initialize counter
.loop:
    cmp x3, x1      // Compare counter with size
    b.ge .loop_end  // Branch if counter >= size
    
    // Loop body here
    
    add x3, x3, #1  // Increment counter
    b .loop         // Branch back to loop start
.loop_end:
```

## Implementation Tips

### For RLE Compression:
1. **Start with first element** as current value, count = 1
2. **Loop through remaining elements**
3. **If same as current**: increment count
4. **If different**: store [current_value, count], update current_value, reset count
5. **Don't forget** to store the final pair after the loop

### For Delta Compression:
1. **Store first value** directly: `output[0] = input[0]`
2. **Loop through remaining elements**
3. **Calculate delta**: `delta = input[i] - input[i-1]`
4. **Store delta** (consider packing multiple deltas per word)
5. **Return total output size**

### For Pattern Search:
1. **Initialize match counter** to 0
2. **Loop through all elements**
3. **Compare each element** with search value
4. **If match**: increment counter
5. **Return final counter**

## Grading Criteria

### Correctness (50%)
- **RLE**: Algorithms produce valid compressed data (20%)
- **Delta**: Compressed data can be decompressed correctly (20%)
- **Search**: Correctly finds all pattern matches (10%)

### Efficiency (30%)
- **Compression ratios**: Achieves expected performance (20%)
- **Search performance**: Efficient linear search (10%)

### Code Quality (20%)
- **Assembly syntax**: Proper ARM64 assembly code
- **Calling conventions**: Follows AAPCS64
- **Register usage**: Proper preservation and usage
- **Comments**: Clear explanation of algorithm steps

## Testing Strategy

### Phase 1: Basic Implementation
```bash
make clean && make
./sigscan data/good_rle_data.csv -rle -stats
```

### Phase 2: Search Function
```bash
./sigscan data/good_rle_data.csv -rle -search "100" -stats
```

### Phase 3: Delta Compression
```bash
./sigscan data/good_delta_data.csv -delta -stats
```

### Phase 4: Full Verification
```bash
./verify_compression.sh data/good_rle_data.csv rle
./verify_compression.sh data/good_delta_data.csv delta
```

## File Structure
```
student_assignment/
├── src/
│   ├── main.c              # Main program (provided)
│   ├── compression.s       # YOUR IMPLEMENTATION HERE
│   ├── compression.c       
│   ├── utils.s             # Utility functions (provided)
│   └── memory.s            # Memory management (provided)
├── include/
│   └── project.h           # Function declarations (provided)
├── data/
│   ├── good_rle_data.csv   # RLE test data
│   ├── good_delta_data.csv # Delta test data
│   └── sample_data.csv     # Additional test data
├── Makefile                # Build system (provided)
└── verify_compression.sh   # Testing script (provided)
```

## Getting Started

1. **Read the algorithm descriptions** in `src/compression.s`
2. **Start with search_pattern** (simplest algorithm)
3. **Implement RLE compression** next
4. **Test with RLE data** and verify correctness
5. **Implement Delta compression** last
6. **Test with Delta data** and verify correctness
7. **Run verification scripts** to confirm lossless compression

## Common Pitfalls to Avoid

1. **Not preserving registers**: Always save/restore callee-saved registers
2. **Off-by-one errors**: Be careful with array bounds
3. **Forgetting final elements**: Handle the last group in RLE
4. **Incorrect addressing**: Use proper scale factors for memory access
5. **Not handling edge cases**: Empty arrays, single elements, etc.

Good luck with your implementation


# Compile with debug info
make clean && make CFLAGS="-g -O0"

# Debug assembly functions
```gdb ./sigscan
(gdb) break rle_compress
(gdb) run data/good_rle_data.csv -rle
(gdb) stepi                    # Step by instruction
(gdb) info registers           # Check register values
(gdb) x/10w $x2               # Examine output memory
```
