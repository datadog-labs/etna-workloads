Reproducer: `repro.sql` loads the corrupt fts5 database from fts5corrupt3-80.0 via `.open --hexdb`, then runs the query from test 80.1 (snippet/highlight with an ORDER BY subquery).

Clean shell: `Error: database disk image is malformed` (exit 1).
Buggy shell: assertion failure `fts5SeekCursor: Assertion CsrFlagTest(pCsr, FTS5CSR_REQUIRE_CONTENT) failed` (abort, exit -6), because fts5SorterNext no longer sets FTS5CSR_REQUIRE_CONTENT at EOF.
