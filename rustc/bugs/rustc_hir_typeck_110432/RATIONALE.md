# Adapted injection for Report reason why index impl is not satisfied deeply

Fix: https://github.com/rust-lang/rust/commit/770c303c005261aa997e6a3a1b762c2831768365

# Rationale
File: compiler/rustc_hir_typeck/src/expr.rs, fn check_expr_index (the `None =>` arm).
Removed the loop "Attempt to *shallowly* search for an impl which matches, but has nested obligations which are unsatisfied" calling `find_and_report_unsatisfied_index_impl` over autoderef steps. This re-expresses fix hunk `@@ -2800,6 +2803,17 @@` (which added that loop). Without it, a failed index falls straight to E0608 "cannot index into a value" instead of reporting the unsatisfied nested `V: Eq`/`V: Hash`.
The helper (fix hunk `@@ -2843,6 +2857,89 @@`) is kept but marked `#[allow(dead_code)]` so the build stays warning-free; the imports hunks are not relevant.
