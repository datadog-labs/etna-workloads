# Adapted injection for layout_of: put back not-so-unreachable case

Fix: https://github.com/rust-lang/rust/commit/a825e37fe4dba0e8b33ed05611ba130d396a5509

# Rationale
File compiler/rustc_ty_utils/src/layout.rs, fn extract_const_value.
Fix hunk `@@ -147,12 +147,25 @@ fn extract_const_value`: split `ConstKind::Unevaluated(_)` out of the
`Param | Expr | Unevaluated` arm into its own arm returning `LayoutError::Unknown` when not generic.
In 1.99.1 Unevaluated is renamed `ConstKind::Alias(_, _)`; I removed that separate arm and merged Alias back into
the `Param | Expr` arm, which does `bug!("failed to normalize const, but it is not generic")` (ICE) for non-generic consts.
