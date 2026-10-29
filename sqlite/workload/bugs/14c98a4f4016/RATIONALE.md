# Rationale

Fix hunk (src/where.c, sqlite3WhereEnd): in the IN-loop epilogue of a LEFT JOIN,
OP_IfNoHope must come *after* the OP_IfNotOpen/OP_IfNullRow guard. Otherwise
OP_IfNoHope reads pIn->iBase, which is uninitialized when the right-hand
cursor was never opened.

In 3.54.1 the guard is OP_IfNullRow (formerly OP_IfNotOpen) and the code uses
a `bEarlyOut` flag. I reversed the order in src/where.c:
- OP_IfNoHope is emitted first, jumping `+2+(iLeftJoin!=0)` (over the guard and
  the Next/Prev), as in the pre-fix code.
- OP_IfNullRow follows, with its jump target back to `+2` (no longer needs to
  skip an IfNoHope).
The retargeting of the OP_IsNull is kept as-is.

## Oracle results
test/in6.test: in6-3.100 hits the assertion
`memIsValid(&r.aMem[ii])` in sqlite3VdbeExec (uninitialized register read by
OP_IfNoHope); the run aborts, so in6-3.110..3.130 also fail.
