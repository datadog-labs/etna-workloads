# Adapted injection for Fix incorrect suggestion for undeclared hrtb lifetimes in where clauses.

Fix: https://github.com/rust-lang/rust/commit/4ebbb5f048797598e22916532b94517285492f03

# Hunk: compiler/rustc_resolve/src/late/diagnostics.rs, suggest_introducing_lifetime_filtered
Removed the `if let LifetimeBinderKind::WhereBound = kind && ... current_where_predicate ... bounded_ty.id == binder` block that
collects inner `for<..>` binders (`rm_inner_binders`, extra `binder_idents`). Re-expresses fix hunk
`@@ -2761,11 +2778,53 @@` (the "special case binders: Change `T: for<'a> Trait<T> + 'b` to `for<'a, 'b> T: Trait<T> + 'b`" block).
So for `T: for<'a> Trait1<T> + 'b` the suggestion is `for<'b> T: ...` with the inner `for<'a>` kept, and no removal span is passed
(the `rm_inner_binders` vec is always empty, matching pre-fix behaviour). `binder: _` restored (fix hunk `-LifetimeRibKind::Generics { binder: _, ...`).
