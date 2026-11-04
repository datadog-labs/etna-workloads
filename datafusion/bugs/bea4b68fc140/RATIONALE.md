# Rationale

Fix hunk: `datafusion/sql/src/parser.rs`, `impl fmt::Display for CreateExternalTable` — the fix added a `WITH ORDER (...)` block (when `order_exprs` is non-empty) between `STORED AS` and `LOCATION`.

In 55.2.0 the same block exists (the `LOCATION` part was since rewritten to handle multiple `locations`, so the hunk doesn't reverse directly). I removed the `if !self.order_exprs.is_empty() { ... }` block, leaving the pre-fix output: `WITH ORDER` is silently dropped from the displayed definition (used by `SHOW CREATE TABLE` / `information_schema.views`).

Oracle: `information_schema.slt` fails on the `SHOW CREATE TABLE abc_ordered`, `abc_multi_order` and `abc_order_nulls` cases; the actual output lacks `WITH ORDER (...)`.
