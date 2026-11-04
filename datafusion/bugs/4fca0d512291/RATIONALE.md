# Rationale

Changed `datafusion/sql/src/expr/unary_op.rs`, `UnaryOperator::Plus` arm. This reverses the fix's single implementation hunk. The arm again returns the planned operand without checking its type, as it did before the fix. The 55.2.0 arm had the same numeric/interval/timestamp check, plus a Diagnostic. I removed the whole check, so unary `+` accepts any type.

Oracle: `scalar.slt` fails at `query error ... Unary operator '\+' only supports numeric, interval and timestamp types` / `SELECT +true`. The query now succeeds, but the test expects a planning error.
