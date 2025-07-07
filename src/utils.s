// utils.s - miscellaneous utilities in ARM64 assembly
    .text
    .global calculate_compression_ratio
    .type calculate_compression_ratio, %function
// size_t calculate_compression_ratio(size_t original, size_t compressed)
calculate_compression_ratio:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    cbz x0, .ratio_end
    mov x2, x0             // preserve original_size
    mov x0, x1             // x0 = compressed_size
    mov x3, #100
    mul x0, x0, x3         // compressed_size * 100
    udiv x0, x0, x2        // / original_size
.ratio_end:
    ldp x29, x30, [sp], #16
    ret

    .global print_ascii_chart
    .type print_ascii_chart, %function
// void print_ascii_chart(const int32_t *data, size_t size)
print_ascii_chart:
    stp x29, x30, [sp, -16]!
    stp x19, x20, [sp, -16]!   // save callee-saved register
    stp x21, x22, [sp, -16]!   // save more callee-saved registers
    mov x29, sp

    mov x19, x0           // preserve data pointer in x19
    mov x20, x1           // preserve size in x20
    mov x21, #0           // index in x21
.loop_chart:
    cmp x21, x20
    b.ge .chart_done
    ldr w0, [x19, x21, lsl #2]  // load value into w0 for printf
    bl print_value         // custom print value
    add x21, x21, #1
    cmp x21, #20          // emergency exit after 20 iterations
    b.ge .chart_done
    b .loop_chart

.chart_done:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

print_value:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    // x0 already contains the value to print
    mov x1, x0             // move value to x1 for printf
    adrp x0, format_str
    add x0, x0, :lo12:format_str
    bl printf
    ldp x29, x30, [sp], #16
    ret

    .data
format_str:
    .asciz "%d\n"

    .text
    .global array_copy
    .type array_copy, %function
// void array_copy(const int32_t *src, int32_t *dest, size_t size)
array_copy:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    cbz x2, .copy_done
    mov x3, #0
.copy_loop:
    ldr w4, [x0, x3, lsl #2]
    str w4, [x1, x3, lsl #2]
    add x3, x3, #1
    cmp x3, x2
    b.lt .copy_loop
.copy_done:
    ldp x29, x30, [sp], #16
    ret

    .global int_to_string
    .type int_to_string, %function
// void int_to_string(int64_t value, char *buffer)
int_to_string:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    mov x2, x1
    mov x1, x0
    adrp x0, fmt_int
    add x0, x0, :lo12:fmt_int
    bl sprintf
    ldp x29, x30, [sp], #16
    ret

    .data
fmt_int:
    .asciz "%ld"
