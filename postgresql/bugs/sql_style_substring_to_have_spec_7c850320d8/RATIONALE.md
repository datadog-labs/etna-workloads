# Rationale

File: src/backend/utils/adt/regexp.c, function similar_escape_internal (traces to the fix.patch hunk that emits escape-double-quote part separators).

Reverted the separator emission to the old alternating `(` / `)` (`nquotes++ % 2`). This drops the `){1,1}?(` and `){1,1}(?:` greediness markers and the error for more than two escape-double-quotes. Part1 is greedy again, so SQL substring() returns the wrong match.

The larger palloc size and the comment-only hunks were left alone. The bigger allocation is harmless.

Oracle case expected to fail: src/test/regress||strings
