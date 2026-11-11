# Adapted injection for Reject const projections behind trait aliases that mention `Self`

Fix: https://github.com/rust-lang/rust/commit/618c15eb6ce195c8ec19f4501addb728eeb81a95

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs, function lower_trait_object_ty (projection_bounds loop).
Re-expresses the hunk `@@ -140,29 +140,29 @@` which replaced `if let Some(term_ty) = &b.term.as_type() { ... references_self ...}`
with `let references_self = proj.term.walk().any(|arg| arg == dummy_self.into());`.
Bug restored: only type terms are checked for `Self`; const terms (assoc const bindings behind trait aliases) are not, so `Self` leaks and ICEs.
(1.99.1 already had the renamed diagnostic, so only the term check was reverted.)
