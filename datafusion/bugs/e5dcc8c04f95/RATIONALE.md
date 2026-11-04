# Rationale

Fix (#17357, "lazy evaluation for coalesce") replaced the eager `invoke_with_args` of
`CoalesceFunc` with a `simplify` that rewrites `coalesce(a, b, ...)` into
`CASE WHEN a IS NOT NULL THEN a ... ELSE last END`, so later arguments are evaluated lazily.

Change (only `datafusion/functions/src/core/coalesce.rs`):
- Removed the `simplify` method (reverses the added `simplify` hunk and its imports:
  `CaseBuilder`, `ExprSimplifyResult`, `SimplifyContext`, `plan_err`).
- Restored the old eager `invoke_with_args` (zip/and/is_null based) in place of
  `internal_err!("coalesce should have been simplified to case")`, plus its imports.
  Equivalent to the pre-fix code, byte for byte.

55.2.0's `conditional_arguments`/`short_circuits` are left untouched; they don't
make evaluation lazy without the CASE rewrite.

Oracle: `select.slt` fails.
- The explain of `coalesce(1, y/x)` shows an unsimplified `coalesce(...)` rather than the folded plan.
- `select coalesce(1, y/x), coalesce(2, y/x) from t;` fails with "Divide by zero error",
  because the second argument is evaluated eagerly (the exact bug the fix addressed).
