# Rationale

Changed `datafusion/functions/src/string/replace.rs`, `apply_replace`, empty-`from` branch.

Fix hunk reversed: the `from.is_empty()` branch that writes `input` verbatim (`append_value(string)`)
is restored to the pre-fix behaviour: write `to`, then for each char write the char followed by `to`
(via `try_append_with`, the 55.2.0 equivalent of `append_with`). So `replace('abc','','x')` gives `xaxbxcx`.
Bench/test hunks of the fix were not touched.

Oracle: all four new `string_literal.slt` replace cases (Utf8, Dictionary, Utf8View, LargeUtf8)
fail with `xaxbxcx` instead of `abc`.
