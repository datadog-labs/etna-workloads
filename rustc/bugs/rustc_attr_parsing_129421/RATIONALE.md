# Adapted injection for add repr to the allowlist for naked functions, and test that it works

Fix: https://github.com/rust-lang/rust/commit/c3000ad3baf4c135abc5740c09f726a8862c2ac3

# Rationale
File: compiler/rustc_attr_parsing/src/attributes/codegen_attrs.rs, naked attribute parser `finalize`, `ALLOW_LIST`.
Re-expresses fix hunk `@@ -516,6 +516,7 @@` in check_attr.rs (`+            sym::repr,`): the fix added `repr` to the naked-function allowlist. The list moved to rustc_attr_parsing in 1.99.1. I removed `sym::repr` and also `sym::rustc_align` (the modern spelling of `#[repr(align)]`, which the fix's test now uses), so `#[rustc_align(16)] #[unsafe(naked)]` is rejected with E0736 again.
