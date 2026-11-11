# Adapted injection for Do not feed anon const a type that references generics that it does not have

Fix: https://github.com/rust-lang/rust/commit/ed6dfddfeb345e0fe94ef735a54d6290d278a6b8

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/mod.rs, function lower_const_arg (anon const branch).
Removed the check `if ty.has_non_region_param() { span_err("anonymous constants referencing generics are not yet supported"); feed error type; return error const }`.
Re-expresses fix hunk `@@ -2324,6 +2323,16 @@` which added that check (with the comment "We error when the type contains unsubstituted generics..."). The comment-reordering hunks are cosmetic and not reverted.
Effect: anon const is fed a type referencing parent generics (`T`), causing the old index-OOB/ICE (#137865).
