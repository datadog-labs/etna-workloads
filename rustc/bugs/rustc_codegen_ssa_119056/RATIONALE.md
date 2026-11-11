# Adapted injection for Tolerate overaligned MIR constants for codegen.

Fix: https://github.com/rust-lang/rust/commit/3ea5cfaa11ce82b3d16385e16b770b4749463406

# Rationale
File compiler/rustc_codegen_ssa/src/mir/operand.rs, `OperandRef::from_constant` (the fn containing `let alloc_align = alloc.inner().align;`, line ~220).
Fix hunk `@@ -132,7 +132,7 @@`: `-assert_eq!(alloc_align, layout.align.abi);` / `+assert!(alloc_align >= layout.align.abi);`.
Reverted to `assert_eq!(alloc_align, layout.align.abi);` so overaligned GVN constants ICE in codegen.
