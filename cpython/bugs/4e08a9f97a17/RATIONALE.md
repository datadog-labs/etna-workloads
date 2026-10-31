# Rationale (gh-137078)

Hunks reversed in v3.15.2:

1. `Lib/traceback.py` `_find_keyword_typos`: restored the pre-fix same-line
   filter `token.start[0]+line != end_line+1` in place of
   `the_end = end_line if line == 0 else end_line + 1`. When the source is read
   from a file, `line == 0` (offset-less metadata), so the token line is off by
   one and the typo token on the error line is skipped. This is the defect the fix addressed.
2. `Parser/action_helpers.c` `_PyPegen_register_stmts`: removed the
   `if (p->last_stmt_location.lineno > last_stmt->lineno) return stmts;` guard
   the fix added, so the last-statement location can move backwards.
   (Alone it does not trigger the oracle failure in v3.15.2; the grammar/parser.c
   registration moves from the fix are already in the tree and left as is.)

Not reverted: the `error_code[0] = error_code[0][offset:]` removal; restoring
it did not change the oracle outcome.

Oracle failure: `TestKeywordTypoSuggestions.test_keyword_suggestions_from_file`
fails (e.g. `for x im n:` run from a script prints no "Did you mean 'in'").
The `test_import_from_*` failures reported by check.sh also occur without
these changes.
