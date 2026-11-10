# Adapted injection for Allow for a missing `adt_def` in `NamePrivacyVisitor`.

Fix: https://github.com/rust-lang/rust/commit/21bb1a435907294e50a95359fedcf5ebd5de1959

# Rationale
Fix hunk: `@@ -988,7 +988,10 @@ impl<'tcx> Visitor<'tcx> for NamePrivacyVisitor<'tcx>` in rustc_privacy/src/lib.rs, replacing
`let adt = ...ty_adt_def().unwrap();` with `let Some(adt) = ... else { span_delayed_bug(...); return; }`.
In 1.99.1 the unwrap is already present at that spot (the fix's let-else doesn't exist), but it's unreachable because
two guards keep privacy analysis from seeing erroneous bodies. The bug's precondition (per the commit message: privacy analysis reachable with errors) is restored by removing both:

1. compiler/rustc_privacy/src/lib.rs, `NamePrivacyVisitor::visit_nested_body`: removed the `if tainted_by_errors.is_some() { return; }` early return, so erroneous bodies are visited and `expr_ty(expr).ty_adt_def()` can be None (the `unwrap` the fix guarded).
2. compiler/rustc_interface/src/passes.rs, `analysis`: removed the `has_errors_excluding_lint_errors() -> raise_fatal()` abort before `misc_checking_3` (the early return whose removal in 72b172bdf6 exposed the bug), so check_mod_privacy runs after errors.
