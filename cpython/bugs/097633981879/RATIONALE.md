# Rationale (gh-121650)

Changes (all in tree/Lib/email):

1. `generator.py` `Generator._write_headers` and `BytesGenerator._write_headers`:
   removed the `verify_generated_headers` block (ends-with-linesep check and
   `NEWLINE_WITHOUT_FWSP` check), reversing the fix's `_write_headers` hunk.
   The bytes variant is the same defect added later in the same code path.
   The policy attribute and error class are left in place (harmless, as in pre-fix API).
2. `_header_value_parser.py` `_refold_parse_tree`: restored the old
   `if part.token_type == 'ptext' and set(tstr) & SPECIALS: want_encoding = True`,
   so parts containing newlines are no longer encoded. This reverses the fix's
   `_header_value_parser.py` hunk (v3.15.2 had an extended `vtext` variant of it).

Oracle failures: `TestGenerator.test_verify_generated_headers` (both subtests):
a custom `fold()` returning a header with an embedded `\r\n` or no trailing
newline is written without `HeaderWriteError`, i.e. header injection is possible.
The newline-encoding tests (test_keep_*_encoded_newlines) still pass, since other code in the
current parser still covers that case.
