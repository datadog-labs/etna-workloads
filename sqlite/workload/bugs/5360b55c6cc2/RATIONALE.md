# Rationale

Fix: in `sqlite3VtabCallDestroy`, `ALWAYS(pTab!=0 && pTab->pVTable!=0)` was
wrong because `pTab` can be NULL, e.g. `DROP TABLE dbstat` on an eponymous
virtual table (which is not in the schema hash). The fix made `pTab!=0` a real
check and the drop a no-op.

In 3.54.1 `sqlite3VtabCallDestroy` again has `ALWAYS(pTab!=0)`. That is
harmless only because `tableMayNotBeDropped()` in `src/build.c` rejects
eponymous tables (`TF_Eponymous`) before an OP_VDestroy is ever coded. That
guard is the later code that covers the same case.

## Change
`src/build.c`, `tableMayNotBeDropped()`: removed the `TF_Eponymous` clause.
`DROP TABLE dbstat` then codes OP_VDestroy, `sqlite3FindTable` returns NULL, and
the incorrect `ALWAYS(pTab!=0)` is false. The `sqlite3VtabCallDestroy` code is
left as-is because it already contains the defective ALWAYS.

## Oracle
`test/stat.test` stat-0.1a (`DROP TABLE dbstat`) hits
`Assertion '0' failed` in `sqlite3VtabCallDestroy`. The testfixture aborts, so
the rest of the file (stat-0.1b onward) does not run and counts as failing.
