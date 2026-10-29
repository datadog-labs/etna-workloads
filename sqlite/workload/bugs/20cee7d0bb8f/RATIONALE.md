# Rationale

Change (src/resolve.c, resolveExprStep, TK_FUNCTION): the `Expr.op2` self-reference flag
is now recorded as `pNC->ncFlags & (NC_SelfRef & ~NC_IsCheck)` instead of
`pNC->ncFlags & NC_SelfRef`.

Reverses the fix hunks in resolve.c / expr.c / sqliteInt.h that introduced `NC_SelfRef`
(which includes NC_IsCheck) and stored it in `Expr.op2` so that the function call is coded as
OP_PureFunc with P5 = context. Before the fix, CHECK constraints were not marked
as a pure-function context, so date/time functions using 'now' were not rejected there.
Without NC_IsCheck in the stored flags, OP_PureFunc is not emitted for CHECK constraints
(and sqlite3NotPureFunc never reports "a CHECK constraint").

Failing oracle cases (test/date2.test): date2-600, date2-603, date2-604 (julianday('now') in CHECK
is accepted / evaluated instead of raising "non-deterministic use of julianday() in a CHECK
constraint"; 604 gives a CHECK failure instead), and date2-110 (date('now') in a CHECK).
