# Adapted injection for Relax a debug assertion in codegen

Fix: https://github.com/rust-lang/rust/commit/eb75d20a55e7c6416592a6e9d4d2e7e21e08ce14

# Rationale
File: compiler/rustc_codegen_ssa/src/base.rs, fn `unsized_info` (NOP-unsize branch, principal def ids equal).
Re-expresses the fix hunk `@@ -133,12 +167,8 @@ fn unsized_info` which replaced
`debug_assert_eq!(data_a.principal(), data_b.principal(), ...)` with
`debug_assert!(validate_trivial_unsize(cx.tcx(), data_a, data_b), ...)`.
I restored the old strict-equality assertion, so a subtype (higher-ranked) principal difference trips the assertion.
`validate_trivial_unsize` remains in the tree (unused by this path); the cranelift copy is left unchanged (not built).
