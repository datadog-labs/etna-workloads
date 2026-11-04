# Rationale

Hunk changed: `datafusion/expr-common/src/type_coercion/binary.rs`, `comparison_coercion`
(one line): the numeric/string rule now calls `string_numeric_union_coercion` (coerce to the
string type) instead of `string_numeric_coercion` (coerce to the numeric type).

Reverses the fix hunk that replaced the old `string_numeric_coercion` (numeric/string -> Utf8/LargeUtf8/Utf8View)
in `comparison_coercion` with the numeric-preferring one. The string-preferring helper is the
same logic the old function had (it is what `type_union_coercion` still uses), so comparisons
such as `int_col < '10'` are again done lexicographically on strings.

Oracle failures: `string_numeric_coercion.slt` fails (e.g. `t_float WHERE column1 < '5'` returns
1000.1/325.7/499.9, `column1 = '5'` misses `5`). Other oracle files may also be affected via the same rule.
