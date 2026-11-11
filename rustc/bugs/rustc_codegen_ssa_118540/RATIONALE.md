# Adapted injection for codegen, miri: fix computing the offset of an unsized field in a packed struct

Fix: https://github.com/rust-lang/rust/commit/ef15a8182ba0b6b7b5d6abb9d00eeb93f7cf0247

Bug: offset of unsized field in packed struct rounded up to the field's full dynamic alignment instead of capping at the pack value.

1. compiler/rustc_codegen_ssa/src/mir/place.rs, `PlaceRef::project_field`: removed the "For packed types, we need to cap alignment" block (icmp/select against `packed`) and made `unsized_align` immutable again. Re-expresses hunk `@@ -186,7 +179,16 @@` (`let (_, mut unsized_align) = ...` + packed cap). The now-unused `IntPredicate` import only causes a warning.
2. compiler/rustc_const_eval/src/interpret/projection.rs, field projection: restored `Some((_, align)) => (base_meta, offset.align_to(align))`, dropping `align.min(packed)`. Re-expresses hunk `@@ -163,7 +163,17 @@`.
