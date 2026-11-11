# Adapted injection for Correctly deny late-bound lifetimes from parent in anon consts and TAITs

Fix: https://github.com/rust-lang/rust/commit/52aff538123137fb395a52c4ddb6fba2ef6fed07

# Rationale
One hunk: compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs, `visit_anon_const`-style walk (the `Scope::LateBoundary { s: self.scope, what: "constant", deny_late_regions: true }` at ~line 1053) now has `deny_late_regions: false`.

Re-expresses the fix hunk that renamed `AnonConstBoundary` to `LateBoundary { what }` and made `resolve_lifetime_ref` track `crossed_late_boundary` and emit `CannotCaptureLateBound::Lifetime` for late-bound lifetimes
(`@@ ... fn resolve_lifetime_ref`: `} else if let ResolvedArg::LateBound(_, _, param_def_id) = def && let Some(what) = crossed_late_boundary`).
Before the fix, anon-const boundaries did not reject late-bound lifetimes from the parent, which led to the ICE. Setting deny_late_regions to false for the anon-const boundary restores that (the type/const check is unaffected).
