# Rationale

Fix (gh-105194) made `fstring_format_spec` use `_PyPegen_decoded_constant_from_token`
so escapes in f-string format specs are decoded (and invalid escapes warn).

Changes in tree/ (reverting that grammar hunk and its generated counterpart):
- `Grammar/python.gram`, rule `fstring_format_spec`: `FSTRING_MIDDLE` action goes back to
  `_PyPegen_constant_from_token` (raw token text, no decoding), as before the fix.
- `Parser/parser.c`, `fstring_format_spec_rule`: same one-call change, kept consistent with the grammar.

The helper `_PyPegen_decoded_constant_from_token` still exists (the t-string rule uses it), so the
fix's action_helpers.c/pegen.h hunks are not touched. I left the t-string rule alone since the fix did not cover it.

Oracle: `test_custom_format_specifier` fails. Specifically, the `exec('f"{F():¯\_(ツ)_/¯}"')`
case no longer raises SyntaxWarning ("SyntaxWarning not triggered"), because format-spec escapes are no longer decoded.
