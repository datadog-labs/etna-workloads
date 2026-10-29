# Rationale

Fix hunk (src/json.c, jsonEachColumn, `case JEACH_VALUE`) added a
`sqlite3_result_subtype(ctx, JSON_SUBTYPE)` call when the element is an array or
object. In version-3.54.1 the same code exists (with `p->eMode` in place of the
literal `1`), so I removed that `if` block from `tree/src/json.c`. This restores
the pre-fix behaviour: the `value` column of json_each/json_tree for arrays and
objects lacks the JSON subtype, so passing it to json_insert() etc. treats it as
a string literal.

Oracle: `json101-5.10` fails (the result is `{"a":"[1,2,3]"}` instead of
`{"a":[1,2,3]}`). `json101-5.11` still passes, as it did before the fix.
