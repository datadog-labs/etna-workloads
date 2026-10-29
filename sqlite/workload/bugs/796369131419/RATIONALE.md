# Rationale

Fix hunk reversed: the `update.c` "Initialize the count of updated rows" condition, which the fix extended with `&& !pUpsert`.

In 3.54.1 this is in `sqlite3Update()` (src/update.c, ~line 671). I deleted the `&& pUpsert==0` term. The UPDATE generated for an UPSERT's DO UPDATE clause now allocates `regRowCount` again and emits its own "rows updated" result row. That is the pre-fix behaviour: with `PRAGMA count_changes=ON`, an UPSERT returns extra rows and a wrong count.

The `insert.c` and `delete.c` hunks were refactors that the fix says do not change behaviour. I left them alone.

Oracle result: `upsert1-400` fails. The test expects `{1}` and gets extra count rows from the DO UPDATE path. `upsert1-410` and the other cases still pass.
