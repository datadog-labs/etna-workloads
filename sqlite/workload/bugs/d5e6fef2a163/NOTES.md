repro.sql: a TEMP trigger is defined on aux.t1, and main.t1 also exists. `ALTER TABLE main.t1 RENAME TO t2` is run first.
With the bug, renameResolveTrigger looks up the trigger's table in the schema being edited (zDb) instead of the trigger's own table schema.
For the temp trigger that means looking in the wrong schema and finding nothing, or the wrong table.
Clean shell: renames succeed and the output is `tr|t1` then `tr|t2`.
Buggy shell: aborts with `renameResolveTrigger: Assertion `0' failed` (exit -6).
