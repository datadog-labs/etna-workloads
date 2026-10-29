repro.sql creates an FTS4 table with two rows whose rowids differ by more than 2^63, then runs integrity-check and a MATCH query.
Clean shell: no error. Buggy shell: the signed delta is negative/zero, so it reports "database disk image is malformed" (or an assertion failure).
