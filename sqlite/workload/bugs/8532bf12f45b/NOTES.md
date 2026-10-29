Reproducer (repro.sql): conflict-17.4..17.6 from the fix. Within a transaction, `UPDATE OR REPLACE` hits a "datatype mismatch" on the second row after the first row was already updated (1 -> 10).

Clean: the statement is rolled back, so the final SELECT gives `1|x`, `2|y`.
Buggy: the statement journal isn't used (MayAbort missing), so the partial change persists after COMMIT: `2|y`, `10|x`.
