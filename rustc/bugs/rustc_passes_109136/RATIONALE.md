# Adapted injection for Simplify proc macro signature validity check

Fix: https://github.com/rust-lang/rust/commit/9eae77381ec58cd89346367fc498547c5e30c497

# Rationale
One hunk: compiler/rustc_passes/src/check_attr.rs, `CheckAttrVisitor::check_proc_macro`.
Re-expresses the fix hunk `@@ -2188,100 +2192,66 @@ ... fn check_proc_macro` which added
`// proc macro is not WF.` / `let errors = ocx.select_where_possible(); if !errors.is_empty() { return; }`
(in 1.99.1: `try_evaluate_obligations` + `no_errors`). The parent commit had no such bail-out when the
signature had unsatisfied obligations (e.g. bad projection `<() as Project>::Assoc`), so the signature check
ran on a non-WF signature and emitted extra/duplicate errors. I removed the early return.
The rest of the fix (rewrite to ocx-based check) is already present in 1.99.1 and not reverted wholesale.
