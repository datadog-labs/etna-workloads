Reproducer (`repro.sql`): cast-9.0 from test/cast.test. A view returns CAST(0.0 AS NUMERIC), and the query joins it to a table with `v1.c0=0`, so SQLite builds an automatic index on the view.

The injected patch applies column affinity to the automatic-index entries for views. That turns 0.0 into the integer 0.

- clean shell: prints `0.0`
- buggy shell: prints `0`
