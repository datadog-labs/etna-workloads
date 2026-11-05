# Reintroduced bug
File: src/bin/pg_dump/pg_dump.c, function dumpTableData_insert().

Traces to the fix.patch hunk `if (tbinfo->attgenerated[field])` -> `if (attgenerated[field])`.
I reverted it to `tbinfo->attgenerated[field]`. `field` indexes the fetched result columns, which skip dropped (and, with column inserts, generated) columns. `tbinfo->attgenerated` is indexed by physical attribute number. With dropped columns the two indexes drift apart, so `DEFAULT` is emitted for the wrong column or not emitted for a generated one. The local compacted `attgenerated` array is still built but is no longer read.

Oracle: the pg_dump 002_pg_dump.pl run fails after this change (10039/13808 cases FAIL, mostly 'missing' results, e.g. the `test_schema_plus_large_objects: should not dump ...` cases). I did not look at the logs, so I don't know why so many cases fail.
