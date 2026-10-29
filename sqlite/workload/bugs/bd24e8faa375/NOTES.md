`repro.sql` queries the eponymous virtual table `fts4aux`. Its xConnect fails
because it is called with no arguments, so it returns an error message.

- clean: `Parse error near line 1: invalid arguments to fts4aux constructor`
- buggy: `Parse error near line 1: no such table: fts4aux`

The buggy build returns 0 from sqlite3VtabEponymousTableInit() after a failed
xConnect, so the connect error message is lost.
