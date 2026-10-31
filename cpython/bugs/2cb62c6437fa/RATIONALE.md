# gh-110309: empty constants in f-string format specs

Changed only `_PyPegen_setup_full_format_spec` in `Parser/action_helpers.c`.

1. Pruning loop (fix hunk: the `non_empty_count` / `resized_spec` loop replacing the
   `asdl_seq_LEN(spec) == 1` check). Restored the pre-fix check: an empty constant is
   dropped only when it is the sole element of the spec.
2. v3.15.2 has since added a call to `_PyPegen_concatenate_strings` for specs with 2+
   elements. That call also dropped empty constants (the "Drop all empty contanst
   strings" code in `_build_concatenated_str`), so reverting only hunk 1 changed
   nothing (0 oracle failures). I restored the pre-fix tail, which builds
   `_PyAST_JoinedStr(spec, ...)` directly. The spec is then the raw parser output,
   as it was before the fix, and empty constants next to `{name}` survive.
   `_build_concatenated_str` is untouched.

## Failing oracle case
`test.test_fstring.TestCase.test_ast_fstring_format_spec`: for `f'{1:{name}}'`,
`format_spec.values` has 2 elements (an empty Constant plus the FormattedValue)
instead of 1 (`AssertionError: 2 != 1`).
This is the defect the fix's test guards against.

Side effect: direct JoinedStr construction also skips the constant folding that
`_PyPegen_concatenate_strings` did for specs. The oracle did not flag this.
