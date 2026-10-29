`repro.sql` loads the corrupt FTS3 database from test 22.0 of `fts3corrupt4.test` with `.open --hexdb`, then runs the snippet() query from test 22.1.

I changed two bytes in the dump (page 1 offsets 3536 and 3888). The shell has no `extra_schema_checks` test control, so the corrupt schema names would otherwise be rejected before the query ran. Neither byte affects the FTS data.

- clean: prints seven `0` rows, exit status 0.
- buggy: `fts3SnippetDetails: Assertion 'iCsr>=iStart && (iCsr - iStart)<=64' failed`, abort (exit status -6). The loop guard `iCsr>=iStart` is missing in the buggy build.
