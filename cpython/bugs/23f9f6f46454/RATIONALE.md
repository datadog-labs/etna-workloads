# Rationale

In v3.15.2 the code from the fix lives in `Lib/_ast_unparse.py`, in `_ftstring_helper` (formerly `visit_JoinedStr` in `Lib/ast.py`).

Changes, all reversing the single hunk of fix.patch in `Lib/ast.py`:
- Removed the `fallback_to_repr` flag and the `set(new_quote_types).isdisjoint(quote_types)` check, so `quote_types = new_quote_types` is assigned unconditionally, as before the fix.
- Removed the `if fallback_to_repr:` block (the repr/triple-single-quote fallback).
- Removed the `assert quote_types` that the fix added after the newline filter.

This restores the pre-fix behaviour: when no quote type works for every constant part, the quote list is silently emptied or mismatched, and the output is wrongly quoted.

Oracle: `test_unparse.CosmeticTestCase.test_multiquote_joined_string` fails. The unparsed output (e.g. `f''''{1}"""'`) is a SyntaxError on re-parse. The run had 1 error out of 81 tests.
