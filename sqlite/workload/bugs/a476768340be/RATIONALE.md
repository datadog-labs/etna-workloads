# Rationale

Changed: `src/trigger.c`, `sqlite3TriggerList()`: added `if( pTmpSchema==pTab->pSchema ) p = 0;` before the TEMP-trigger loop.

Reverses the fix's trigger.c hunk. Before the fix, the loop that scans the TEMP trigHash (and attaches the RETURNING pseudo-trigger) ran only when `pTmpSchema!=pTab->pSchema`. The fix made it run for every table. In 3.54.1 the loop runs unconditionally, so skipping it when the table is in TEMP restores the old behaviour. On a TEMP table the RETURNING trigger is therefore never attached, and RETURNING output is lost. I did not revert the build.c `pTabSchema` hunk, because the else-if path in 3.54.1 covers that case.

Oracle cases that fail: returning1-11.1, 11.2, 11.3, 11.5, 11.7 (the new TEMP-table-with-triggers cases return no RETURNING rows), plus 16.0, 17.2.1, 21.1 and 22.1, which also use RETURNING on temp tables.
