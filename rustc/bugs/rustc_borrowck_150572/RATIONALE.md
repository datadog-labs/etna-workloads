# Adapted injection for Improve move error diagnostic for `AsyncFn` closures

Fix: https://github.com/rust-lang/rust/commit/f5f2ca0dc62b4a6d38ba221ef64090172da7f569

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/move_errors.rs, fn report_move_errors path (match on closure type in the deref-of-captured-upvar case).
Removed the `ty::CoroutineClosure(def_id, closure_args)` arm that called `report_closure_move_error(..., ty::Asyncness::Yes)`.
This re-expresses the fix hunk `@@ -472,49 +473,30 @@` which added that arm (guarded by `get_closure_bound_clause_span(*def_id, ty::Asyncness::Yes).is_some()`). Without it, async closures fall to the generic `_` arm and lose the AsyncFn-specific diagnostic.
