# Rationale

Fix gh-124363 stopped decoding the debug-expression text of f-strings (`f'{expr=}'`), so escapes in the expression source were kept raw. In v3.15.2 the code lives in `_get_resized_exprs` in `Parser/action_helpers.c`, not `_PyPegen_joined_str`.

## Hunk changed: `_get_resized_exprs`, JoinedStr (debug) branch
Reverses the fix's new "JoinedStr of two elements" branch, which copies the debug text constant unchanged. Before the fix, `unpack_top_level_joined_strs` flattened the debug JoinedStr into the list, and the main loop then ran `_PyPegen_decode_fstring_part` on the debug constant like any other string part. The edit decodes `first` with `_PyPegen_decode_fstring_part` before storing it. That has the same effect as the old flatten-then-decode path. Only the constant is decoded. The FormattedValue is untouched, as before.

## Oracle failure
`test_fstring.TestCase.test_debug_expressions_are_raw_strings` fails. `f'{b"\N{OX}"=}'` gives `b"🐂"=b'\\N{OX}'` instead of `b"\N{OX}"=b'\\N{OX}'`, so the escape in the expression text is wrongly decoded.
