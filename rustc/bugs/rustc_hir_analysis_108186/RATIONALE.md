# Adapted injection for Move late-bound arg type checks to resolve_bound_vars

Fix: https://github.com/rust-lang/rust/commit/cec7835d7a8ea25b214b6bae5d61f51251b09b8e

# Rationale
File: compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs, `visit_expr` (Closure arm).
Removed the `deny_non_region_late_bound(self.tcx, &mut bound_vars, "closures");` call (and the `mut` on `bound_vars`).
Re-expresses fix hunk `@@ -411,6 +461,8 @@ ... visit_expr`, which added that call (plus `let (mut bound_vars, ...)`) so closure binders with type/const params are rejected in resolve_bound_vars. Without it, `for<T> || -> T {}` is no longer diagnosed.
