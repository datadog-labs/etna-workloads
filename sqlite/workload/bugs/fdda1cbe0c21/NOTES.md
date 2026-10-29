Calls snippet() from a non-full-text query (plain scan of an fts5 table).
On a scan the cursor must set FTS5CSR_REQUIRE_DOCSIZE; the injected bug drops
that, so xColumnSize returns a stale 0 for the column, and snippet() thinks the
snippet reaches the end of the column.
Clean: `one two three...`; buggy: the whole row with no ellipsis.
The test cases themselves use fts5_test_* TCL-registered functions, which the
shell lacks, so snippet() is used as a shell-visible consumer of xColumnSize.
