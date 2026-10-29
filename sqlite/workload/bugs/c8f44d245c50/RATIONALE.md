# Rationale

Fix: snippet() passed NULL (from SQL NULL args) for zOpen/zClose/zEllips; fix added `fts5ValueToText()` mapping NULL to "".

Changes in tree/ext/fts5/fts5_aux.c:
1. Removed `fts5ValueToText()` and restored the three direct
   `(const char*)sqlite3_value_text(apVal[1..3])` calls in fts5SnippetFunction (reverses both fix hunks).
2. In `fts5HighlightAppend()` removed the `&& z` NULL guard. This is a later hardening
   that covers the same NULL-string case from a second path (the bug was effectively fixed twice); without
   reverting it the first change alone does not reproduce the crash.

Oracle: the fts5af test crashes at `fts5af-full-5.2`
(snippet(..., NULL ellipsis, ...)): NULL reaches strlen() in fts5HighlightAppend. The run aborts there, so later cases (5.3/5.4 NULL open/close) are not reached.
