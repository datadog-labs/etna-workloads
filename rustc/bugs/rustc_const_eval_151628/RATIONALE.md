# Adapted injection for Fix ICE in const eval when using packed SIMD with non-power-of-two length

Fix: https://github.com/rust-lang/rust/commit/c45a51397c09a371b13627f28ab75016f8832b32

# Rationale
File: compiler/rustc_const_eval/src/interpret/intrinsics/simd.rs, fn `check_simd_ptr_alignment`.
Re-expresses the fix hunk `@@ -829,7 +828,20 @@ ... check_simd_ptr_alignment`: the fix replaced
`assert_matches!(vector_layout.backend_repr, BackendRepr::SimdVector { .. });` with an is_simd assert plus a match accepting SimdVector or Memory.
I restored the strict assert_matches (only SimdVector), so packed SIMD with non-pow2 length (BackendRepr::Memory) ICEs.
Second hunk: the import. The fix removed `use rustc_data_structures::assert_matches;`; in 1.99.1 assert_matches is `std::assert_matches`, so I added `use std::assert_matches;` at the top.
