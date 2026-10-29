Reproducer: `repro.sql` loads the corrupt database from altercorrupt-2.1 with `.open --hexdb`, then runs `ALTER TABLE t1 DROP COLUMN a;`.

- Clean shell: `Error near line 66: database disk image is malformed` (exit status 1).
- Buggy shell: aborts with `dropColumnFunc: Assertion 'iCol!=0' failed` (SIGABRT).
