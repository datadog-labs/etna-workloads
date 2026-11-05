# Reintroduced bug: consecutive format spaces in to_timestamp/to_date

## Changed hunk
- File: src/backend/utils/adt/formatting.c, function `DCH_from_char`
- Traces to fix.patch hunk `@@ -2839,16 +2839,22 @@ DCH_from_char`, which removed the "skip whitespace after a format space char (non-FX mode)" loop from the separator branch.
- Current code no longer has that shape. Non-FX mode now uses `extra_skip` accounting. The fix limited whitespace skipping to the position just before a field. I re-added a loop that, in non-FX mode, skips all following input whitespace after a format `NODE_TYPE_SPACE` is matched.
- Effect: consecutive spaces in the format string no longer advance over exactly that many input characters. Extra input whitespace is swallowed, which is the original bug.

## Oracle cases expected to fail
- src/test/regress||horology

I had not seen the oracle output when I wrote this, so the failing case is the one I expect, not one I observed.
