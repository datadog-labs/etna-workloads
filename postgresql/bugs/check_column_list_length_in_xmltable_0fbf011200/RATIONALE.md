# Rationale

- File/function: src/backend/parser/parse_relation.c, addRangeTableEntryForTableFunc().
- Traces to the fix.patch hunk in parse_relation.c that adds the check
  `numaliases > list_length(tf->colnames)` with the error
  "%s function has %d columns available but %d columns specified".
- I removed that check. XMLTABLE/JSON_TABLE aliases with too many column names are then accepted silently.
  The extra alias names are not an error, and the error message the tests expect is never raised.
- I did not touch the join-related hunks. Join alias checking already works in addRangeTableEntryForJoin in the current code.

Failing oracle cases: src/test/regress||with, src/test/regress||xml
