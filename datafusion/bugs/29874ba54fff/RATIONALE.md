# Rationale

Fix hunk reversed: `datafusion/expr-common/src/type_coercion/binary.rs` — restored
`regex_comparison_string_coercion` (Utf8View coerces to Utf8 rather than Utf8View) and made
`regex_coercion` call it instead of `string_coercion` (same as the fix's one-line change, reversed).

The physical-expr hunks (separate Utf8View kernels in `binary.rs`) are not reintroduced: in 55.2.0 that
code no longer has the `Utf8View | Utf8` merged arm, and the coercion revert alone restores the bug
(regex/like ops on Utf8View columns are planned with a CAST to Utf8).

Oracle: `string/string_view.slt` fails on the 4 EXPLAIN cases (`~`, `~*`, `!~~`, `!~~*`) that now show
`CAST(col AS Utf8) op Utf8(...)` instead of `col op Utf8View(...)`.
