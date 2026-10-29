Reproducer (repro.sql): a trigger whose body holds a WINDOW definition with an
illegal non-numeric frame bound (`2 NOT IN (SELECT ...) PRECEDING`), then
`ALTER TABLE t1 RENAME`. Adapted from altertab3-12.1/12.2.

Clean shell: the RENAME fails with "error in trigger AFTER: no such column: d" (rc=1).
Buggy shell: walkWindowList no longer walks pStart/pEnd, so the rename-token
map is left inconsistent and the shell aborts with
`renameTokenCheckAll: Assertion 'p->p!=pPtr' failed` (rc=134).
