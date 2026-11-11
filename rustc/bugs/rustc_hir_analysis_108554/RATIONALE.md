# Adapted injection for Only look for param in generics if it actually comes from generics

Fix: https://github.com/rust-lang/rust/commit/f851a8aefa5fd61405e8f82989995dce12d93bfc

# Rationale
File: compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs, fn `object_lifetime_default`.
Re-expresses the hunk `@@ -1034,45 +1034,53 @@ fn object_lifetime_default`, which added `match param.source { Generics => <search parent generics>, Binder => ObjectLifetimeDefault::Empty }`.
Buggy behaviour restored: every type param, including `for<U>` binder params, is looked up in the parent item's generics (`generics.params.iter().find(..).unwrap()`), which panics for binder params that are not in the parent generics. The `Binder => Empty` early return is removed.
The other hunks (adding the `source` field) already exist in 1.99.1 and were left alone.
