# Adapted injection for check types of const param default

Fix: https://github.com/rust-lang/rust/commit/8cd12bf8fa1d40edaf580dd112c9b44c4dd8dcd3

# Rationale
File: compiler/rustc_hir_analysis/src/check/wfcheck.rs, fn check_where_clauses.
Removed the `else { ... }` branch after `if !default.has_param() { register_wf_obligation }` that
type-checks a dependent const-param default (`ConstArgHasType(ct, param_ty)` when both types are concrete).
Re-expresses the fix hunk `@@ -1488,6 +1488,39 @@ fn check_where_clauses` which added `} else { // If we've got a generic const parameter we still want to check its type ...`.
