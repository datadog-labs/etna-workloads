# Adapted injection for Imply outlives-bounds on lazy type aliases

Fix: https://github.com/rust-lang/rust/commit/90d6fe2cba2b621b4fc331a1f6dd67c63a7c1033

Fix hunk `@@ -59,6 +59,17 @@ infer_predicates` added `DefKind::TyAlias if tcx.type_alias_is_lazy(item_did) => { insert_required_predicates_to_be_wf(...) }`.
In 1.99.1 (`implicit_infer.rs`, `infer_clauses`) I removed the `DefKind::TyAlias if tcx.type_alias_is_checked(item_did)` arm, so aliases infer no outlives clauses.

The fix's `outlives/mod.rs` hunk (`@@ -21`) added a `DefKind::TyAlias if lazy` arm to `inferred_outlives_of`. I removed the `DefKind::TyAlias if tcx.type_alias_is_checked(item_def_id)` arm in `mod.rs`, so it returns `&[]` for aliases.

I did not re-express the fix's refactor hunks (renames, the `ty::Alias(Weak)` arm in the walk). Those are behaviour-neutral for this bug.
