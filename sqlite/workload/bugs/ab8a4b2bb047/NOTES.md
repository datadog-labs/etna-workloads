Reproducer (repro.sql): an fts5 table using the trigram tokenizer, whose tokens
overlap/are adjacent (like the test's custom tokenizer), then snippet() with a
small window so the range end falls inside an open highlight.

Clean: `>abc<de...` and `...>cde<f...`.
Buggy: `>abcde<...` and `...>cdef<...` (highlight extends past the match, because
fts5HighlightCb no longer closes an open highlight at the range end).
The fts5tokenizer2 test uses a TCL-only tokenizer, so trigram is the shell stand-in.
