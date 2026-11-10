# Adapted injection for fix: Check empty SIMD vector in inline asm

Fix: https://github.com/rust-lang/rust/commit/6948343b9fd4855377fd68c93b9c027d525df590

# Rationale
File: compiler/rustc_hir_typeck/src/inline_asm.rs (the code moved from rustc_hir_analysis/src/check/intrinsicck.rs), fn `get_asm_ty`, `ty::Adt(adt, args) if adt.repr().simd()` arm.
Removed the `if fields.is_empty() { return Err(NonAsmTypeReason::EmptySIMDArray(ty)); }` guard.
Re-expresses fix hunk `@@ -102,6 +103,9 @@ ... ty::Adt(adt, args) if adt.repr().simd()` which added that guard. Without it, `fields[FieldIdx::ZERO]` indexes an empty vec (ICE) for `struct A();` as asm operand.
The enum variant and error arm (other fix hunks) are left in place, now unreachable.
