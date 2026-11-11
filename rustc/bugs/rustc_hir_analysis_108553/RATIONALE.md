# Adapted injection for Deny capturing late-bound non-lifetime param in anon const

Fix: https://github.com/rust-lang/rust/commit/cbf4d4e3a5a1feeeedf605ffb8894c7e391f0f2f

# Rationale
File: compiler/rustc_hir_analysis/src/collect/resolve_bound_vars.rs, fn `resolve_type_ref`.

In 1.99.1 the fix's `Scope::AnonConstBoundary` became `Scope::LateBoundary { what: "constant", .. }`
(pushed in `visit_anon_const`). The fix hunk `@@ -1351,6 +1373,7 @@ ... let mut crossed_anon_const = false;`
plus `Scope::AnonConstBoundary { s } => { crossed_anon_const = true; scope = s; }` and
`if let ResolvedArg::LateBound(..) = def && crossed_anon_const { ...emit CannotCaptureLateBoundInAnonConst }`
is what makes late-bound type/const params captured in an anon const an error.
Reintroduced the pre-fix behaviour: the LateBoundary arm no longer records the crossing when `what == "constant"`,
so no error is emitted and the late-bound param silently resolves.
