repro.sql runs fts4 integrity-check on a table with prefix indexes while its data is still uncommitted (pending in the in-memory hash, inside BEGIN).
Clean: no output, exit 0. Buggy: segfault (exit -11), because fts3 no longer passes isScan as isPrefix when reading pending terms, so the integrity-check's scan misses the pending data.
