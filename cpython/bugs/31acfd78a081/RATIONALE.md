# Rationale
Fix hunk: Lib/pdb.py `code` property, `io.open(self)` -> `io.open_code(self)`.
In v3.15.2 this is `_ScriptTarget.code` (Lib/pdb.py:232), which uses `io.open_code(self._target)`. I reverted it to `io.open(self._target)`, so the script is read as text in the locale encoding and ignores the source's coding cookie. It also bypasses the open-code hook.

Oracle: `test.test_pdb.PdbTestCase.test_non_utf8_encoding` fails. pdb crashes when it runs the scripts in `encoded_modules`. check.sh reported 1 failure in test_pdb.
