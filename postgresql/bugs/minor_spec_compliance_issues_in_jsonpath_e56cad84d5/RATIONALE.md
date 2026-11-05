# Rationale

File: src/backend/utils/adt/jsonpath_scan.l (lexer rules), tracing to the jsonpath_scan.l hunks of fix.patch.

The fix removed non-standard single-quoted string support from the jsonpath lexer. I put it back:
- re-added the exclusive `xsq` state and its comment line;
- excluded `'` from the `other` character class, and made `<xnq>` terminate on `'`;
- added `xsq` to the shared escape rules and the unterminated-string `<<EOF>>` rule;
- re-added `<xsq>\'` (returns STRING_P), `<xsq>[^\\\']+`, and the INITIAL `\'` rule that begins xsq.

Effect: `'abc'` is accepted as a jsonpath string and `'` is no longer an ordinary identifier character, contrary to the spec.

Oracle cases expected to fail: src/test/regress||jsonpath, src/test/regress||jsonpath_encoding (confirm with oracle output).

## Additional hunk (same file, same fix.patch hunks)
Restored the pre-fix escape handling: re-added `<xnq,xq,xvq,xsq>\\[\"\'\\]` (explicit escapes), and changed `\\.` back to raise "escape sequence is invalid" instead of emitting the literal character (fix.patch: `-...\\. yyerror(... "escape sequence is invalid")` / `+...\\. addchar(...)`). The test `select '"\z"'::jsonpath` then errors.

## Oracle result
FAIL: src/test/regress||jsonpath. Pass: jsonpath_encoding.
(Single-quote support alone did not fail any case; the escape change does.)
