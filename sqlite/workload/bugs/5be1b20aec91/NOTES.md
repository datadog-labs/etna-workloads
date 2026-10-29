repro.sql loads the corrupt FTS3 database from fts3corrupt4 test 32.0 via `.open --hexdb`, then runs the 32.1 UPDATE.
The shell can't disable extra_schema_checks (the test harness does), so t2's rootpage byte in the dump was changed from 7 to 2 to get past schema loading; t2 is unrelated.
Clean: "Error: database disk image is malformed", exit 1 (fts3SegWriterAdd checks iFree==LARGEST_INT64).
Buggy: the check is missing, so the UPDATE succeeds silently, exit 0.
