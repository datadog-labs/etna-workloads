# Rationale

Fix hunk (src/pragma.c): added `if( pTab->tnum<1 ) continue;  /* Skip VIEWs or VIRTUAL TABLEs */`
in the integrity_check per-table loop so VIEWs (which reuse Table.pCheck for their
named-column list) aren't treated as tables with CHECK constraints.

In 3.54.1 the equivalent line is `if( !IsOrdinaryTable(pTab) ) continue;` (src/pragma.c, ~line 1841,
in the PRAGMA integrity_check table loop). I removed it, restoring the pre-fix behavior.
A VIEW with named columns then reaches the CHECK-constraint code (`pTab->pCheck`), which
tries to compile the column-name list as CHECK expressions.

Oracle: test/check.test check-10.1 (CREATE VIEW v1(y) ...; PRAGMA integrity_check)
fails: `sqlite3ExprIfTrue: Assertion `0' failed` (crash).
