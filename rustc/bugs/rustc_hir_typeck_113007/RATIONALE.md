# Adapted injection for Revert "Structurally resolve correctly in check_pat_lit"

Fix: https://github.com/rust-lang/rust/commit/e304a1f13b456df877cae8ca27bf360b1d0c89fc

# compiler/rustc_hir_typeck/src/pat.rs, FnCtxt::check_pat_lit
In the byte-string arm, the guard `self.resolve_vars_with_obligations(inner_ty).is_slice()` is changed to `self.structurally_resolve_type(span, inner_ty).is_slice()`.
This re-expresses the fix hunk `@@ -393,8 +393,9 @@ ... check_pat_lit`, which replaced the parent's
`&& self.structurally_resolved_type(span, inner_ty).is_slice()` (eagerly requiring the inner type to be known,
erroring on an inference variable) with a non-erroring check. 1.99.1 renamed the helpers, so this restores the eager structural resolution of the inner type.
