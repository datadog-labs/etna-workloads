# Adapted injection for Error on alignments greater than `isize::MAX`

Fix: https://github.com/rust-lang/rust/commit/6fc7ce43d2f2cd2fef1b75c9c59f13f312e0d9d8

# Rationale
File: compiler/rustc_attr_parsing/src/attributes/repr.rs, fn `parse_alignment`.
In 1.99.1 the fix's logic moved from rustc_passes check_attr.rs (`check_align_value`, hunk `@@ -1892,6 +1895,45 @@` with
`if val > max { emit_err(InvalidReprAlignForTarget ...` where `max = Size::from_bits(pointer_width).signed_int_max()`)
into attribute parsing. I removed the `alignment larger than isize::MAX bytes` check, so alignments > isize::MAX
(e.g. 32768 on msp430) are accepted again, as before the fix.
