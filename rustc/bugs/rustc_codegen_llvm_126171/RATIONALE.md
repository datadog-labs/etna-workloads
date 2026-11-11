# Adapted injection for fix simd_bitmask return type for non-power-of-two inputs, and add tests

Fix: https://github.com/rust-lang/rust/commit/e9dd39cda49c260213f73af4b0ba05cecb292b39

# Rationale
File: compiler/rustc_codegen_llvm/src/intrinsic.rs, fn generic_simd_intrinsic, `simd_bitmask` branch (~line 2355).
Re-expresses fix hunk `@@ -1379,17 +1379,16 @@`: restored
`let expected_int_bits = in_len.max(8);` and
`let expected_bytes = expected_int_bits / 8 + ((expected_int_bits % 8 > 0) as u64);`
in place of `in_len.max(8).next_power_of_two()` / `in_len.div_ceil(8)`. For non-power-of-two lengths (e.g. 10, 20) the expected return type/array size is wrong, so valid code is rejected/miscompiled.
Other hunks (select_bitmask, comment-only) not changed.
