# Adapted injection for Fix ICE for repr simd on non struct

Fix: https://github.com/rust-lang/rust/commit/112d833ea5c72f89078069ffc5d10da5b1adf2ca

compiler/rustc_hir_typeck/src/inline_asm.rs, `InlineAsmCtxt::get_asm_ty`, arm `ty::Adt(adt, args) if adt.repr().simd()`:
removed the `if !adt.is_struct() { span_delayed_bug(...); return Err(NonAsmTypeReason::Tainted(guar)); }` guard.
Re-expresses fix hunk `@@ -93,6 +93,14 @@` which added the `!adt.is_struct()` check (in 1.99.1 it returns Tainted). Without it, `adt.non_enum_variant()` is hit on a zero-variant enum with repr(simd) -> ICE.
