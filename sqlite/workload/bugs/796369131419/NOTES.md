Reproducer (`repro.sql`): upsert1-400 from test/upsert1.test. With `PRAGMA count_changes=ON`, a multi-row
INSERT ... ON CONFLICT DO UPDATE should emit a single "rows inserted" result row (`1`).
The buggy shell also emits a result row from the nested UPDATE of each upsert, so it prints `1` four times; the clean shell prints `1` once.
