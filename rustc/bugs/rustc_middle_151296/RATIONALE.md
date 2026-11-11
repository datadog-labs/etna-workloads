# Adapted injection for fix: allow to print const array as raw bytes only if possible to do so

Fix: https://github.com/rust-lang/rust/commit/ff97a6a7f4a357ce95219a414bcd00d6e3d658a8

# Rationale
1. compiler/rustc_middle/src/ty/consts/valtree.rs, `Value::try_to_raw_bytes`: restored the unchecked conversion
   `map(|ct| ct.try_to_value().unwrap().to_leaf().to_u8())` instead of the fallible `Option<Vec<u8>>` collect.
   Re-expresses fix hunk `@@ -147,7 +147,12 @@ impl<'tcx> Value<'tcx>` (old `to_leaf().to_u8()` replaced by `try_to_leaf()?...collect::<Option<..>>()?`).
   (1.99.1 had additional type checks; the unchecked form panics on non-leaf elements.)
2. compiler/rustc_middle/src/ty/print/pretty.rs, `pretty_print_const_valtree`: array-of-u8 arm lost its
   `&& let Some(bytes) = cv.try_to_raw_bytes(..)` guard and again does `unwrap_or_else(|| bug!(...))`.
   Re-expresses fix hunk `@@ -1911,14 +1911,16 @@` .
