# Rationale

Fix hunk (src/vdbe.c, OP_VUpdate): added `p->nChange++;` after a successful xUpdate so
virtual-table changes are counted like real-table changes (ticket #3038).

In 3.54.1 the increment lives in an `else` branch of the
`(rc&0xff)==SQLITE_CONSTRAINT && bConstraint` test in OP_VUpdate (src/vdbe.c).
I removed that `else { p->nChange++; }`, restoring the pre-fix behaviour: xUpdate
(INSERT/UPDATE/DELETE on a virtual table) never bumps the change counter.

Failing oracle cases (test/vtab1.test): vtab1-6-3.1.2, 6-4.1, 6-5.1, 6-6.1,
6-7.1.2, 6-7.3, 6-8.3 — `db changes` returns 0 instead of 1/2.
