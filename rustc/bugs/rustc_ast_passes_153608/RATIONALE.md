# Adapted injection for ast_passes: unsupported arch w/ scalable vectors

Fix: https://github.com/rust-lang/rust/commit/342ad0401a16aebfa2e2160a099764168a4fe2f5

# Rationale
File: compiler/rustc_ast_passes/src/ast_validation.rs, `ItemKind::Struct` arm of AstValidator::visit_item.
Removed the `if !self.sess.target.arch.supports_scalable_vectors() ... emit_err(ScalableVectorBadArch{span: attr.span})` block (and the `if let Some(attr)` now `is_some()`).
Re-expresses fix hunk `@@ -1371,11 +1371,16 @@ ... ItemKind::Struct`, which added
`if !self.sess.target.arch.supports_scalable_vectors() { ...emit_err(errors::ScalableVectorBadArch { span: attr.span }) }`.
The other hunks (error struct, Arch::supports_scalable_vectors) remain as they are harmless without the check.
