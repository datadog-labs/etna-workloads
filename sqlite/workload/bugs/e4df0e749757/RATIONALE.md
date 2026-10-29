# Ticket #1737: quoted trigger names missed by the duplicate check

Fix hunk reversed: `sqlite3BeginTrigger` in src/trigger.c. Before the fix, the
existing-trigger lookup used the raw token length (`pName->n+1`, quotes
included) instead of the dequoted name (`strlen(zName)`). A quoted or
bracketed name therefore never matched an existing trigger.

In 3.54.1 the hash API takes no length, so the same defect is restored by
looking up the raw token text (`pName->z`, `pName->n`, copied to a
NUL-terminated string) instead of the dequoted `zName`. The other fix hunks
(`sqlite3FinishTrigger`, `sqlite3DropTrigger`, `sqlite3UnlinkAndDeleteTrigger`)
are length-argument changes with no equivalent left, so I did not touch them.

Oracle cases that fail: trigger1-1.2.2 (`CREATE TRIGGER "tr1"`) and
trigger1-1.2.3 (`CREATE TRIGGER [tr1]`). Both should report "already exists"
but the duplicate is not detected.
