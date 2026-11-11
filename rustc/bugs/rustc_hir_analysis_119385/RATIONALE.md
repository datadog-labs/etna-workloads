# Adapted injection for Propagate the resolved type of assoc const bindings via query feeding

Fix: https://github.com/rust-lang/rust/commit/8bb49e22b550b9ccdca3a1f9bc1e52532ec39635

# Rationale
One hunk: compiler/rustc_hir_analysis/src/hir_ty_lowering/bounds.rs, `lower_assoc_item_constraint`, `Equality { term: Term::Const }` arm.

In 1.99.1 the query-feeding design of the fix (type_of_assoc_const_binding) no longer exists; the const's type is computed from `projection_term` (alias built from the candidate, possibly a supertrait ref) and passed straight to `lower_const_arg`. The fix hunk (`@@ -78,35 +78,10 @@ fn anon_const_type_of`) replaced the old `type_of` code that looked the const up only in the binding's own trait (`tcx.associated_items(trait_def_id)` -> "Could not find associated const on trait" error type) with the type resolved via the supertrait-aware candidate. I re-express the old behaviour: when the candidate trait differs from `trait_ref.def_id()` (const from a supertrait), the type becomes an error type (delayed bug "Could not find associated const on trait").
