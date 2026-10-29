# Rationale

Fix (ticket #1607) hunks in `src/auth.c` `sqlite3AuthRead()`:
1. Added early `return` when `iDb<0` (column of a subquery / temp table has no schema).
2. Strengthened `assert( iDb<nDb )` to `assert( iDb>=0 && iDb<nDb )`.

Reintroduced in `tree/src/auth.c` by reversing both: removed the `if( iDb<0 ) return;` block and restored the assert to `assert( iDb<pParse->db->nDb )`. In 3.54.1 the code is the same logic (iDb from `sqlite3SchemaToIndex`, then `sqlite3AuthReadCol` indexes `db->aDb[iDb]`), so with iDb==-1 for subquery columns it reads `aDb[-1]` out of bounds.

Oracle: test/auth.test crashes at auth-1.311 (subquery columns with an authorizer set); auth-1.311 onward, including auth-5.2 (the ticket's test), are reported failing as an incomplete run.
