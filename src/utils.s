// utils.s - miscellaneous utilities in ARM64 assembly

    .text
    .global calculate_compression_ratio
    .type calculate_compression_ratio, %function

// size_t calculate_compression_ratio(size_t original, size_t compressed)
calculate_compression_ratio:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    cbz x0, .ret_zero          // if original == 0, return 0
    mov x2, #100               // multiply by 100
    mul x1, x1, x2             // compressed * 100
    udiv x0, x1, x0            // (compressed * 100) / original
    
    ldp x29, x30, [sp], #16
    ret

.ret_zero:
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret

    .global array_copy
    .type array_copy, %function

// void array_copy(const int32_t *src, int32_t *dest, size_t size)
array_copy:
    cbz x2, .copy_done         // if size == 0, return
    mov x3, #0                 // index counter

.copy_loop:
    cmp x3, x2
    b.ge .copy_done
    ldr w4, [x0, x3, lsl #2]   // load src[i]
    str w4, [x1, x3, lsl #2]   // store to dest[i]
    add x3, x3, #1
    b .copy_loop

.copy_done:
    ret

    .global int_to_string
    .type int_to_string, %function

// void int_to_string(int64_t value, char *buffer)
int_to_string:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Call sprintf(buffer, "%ld", value)
    mov x2, x0                 // value
    mov x0, x1                 // buffer
    adrp x1, fmt_int
    add x1, x1, :lo12:fmt_int  // format string
    bl sprintf
    
    ldp x29, x30, [sp], #16
    ret

    .global print_ascii_chart
    .type print_ascii_chart, %function

// void print_ascii_chart(const int32_t *data, size_t size)
print_ascii_chart:
    // Stub implementation - can be enhanced later
    ret

    .data
format_str:
    .asciz "%d\n"

fmt_int:
    .asciz "%ld"
