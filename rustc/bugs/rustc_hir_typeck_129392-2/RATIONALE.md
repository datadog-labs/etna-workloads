# Adapted injection for Evaluating place expr that is never read from does not diverge

Fix: https://github.com/rust-lang/rust/commit/6371ef6e964a72ca3b4c7557312d8808e98f4ff3

# Rationale
File: compiler/rustc_hir_typeck/src/expr.rs, fn check_expr_with_expectation_and_args (the divergence block).
Fix hunk `@@ -238,8 +238,11 @@`: `if ty.is_never() && self.expr_constitutes_read(expr)` (diverge only if place expr is read).
In 1.99.1 that helper is `tcx.expr_guaranteed_to_constitute_read_for_never`; I removed that condition so any `!`-typed expression diverges, even a non-read place expr (e.g. `let _: ! = *x;`). The pat.rs hunk (adds divergence on reading patterns) is not re-expressed; it is already absent from the behaviour needed by the failing tests.
