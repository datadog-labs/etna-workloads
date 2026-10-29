# Rationale

## Changed hunk: src/pragma.c, PRAGMA foreign_key_check, first loop (opens parent tables/indexes)
Reverses the fix hunk replacing `sqlite3LocateTable(pParse,0,pFK->zTo,zDb); if(pParent==0) break;`
with `sqlite3FindTable(...); if(pParent==0) continue;`. The pre-fix code is restored: a missing
parent table raises "no such table" and aborts the pragma instead of being treated as an empty parent.
The later code-generation loop already tolerates pParent==0 (as the fix added); it is never reached
now because the first loop breaks with pParse->nErr>0, so the existing assert still holds.

## Oracle failures
fkey5-9.1.1, 9.1.2, 9.1.3, 9.2.1, 9.2, 9.3, 9.4 (Error: no such table: main.s1) and
fkey5-12.0 (no such table: aux.t2): the same missing-parent-table cases.
