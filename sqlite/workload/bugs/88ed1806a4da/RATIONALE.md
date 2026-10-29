# Rationale

## Hunk changed: src/expr.c, sqlite3CodeRhsOfIN (Bloom filter bookkeeping)

Reverses the fix's first hunk. The fix replaced
`sqlite3VdbeChangeToNoop(v, addrBloom)` (when `dest.iSDParm2==0`, i.e. the
Bloom filter ended up unused) with `sqlite3VdbeGetOp(v, addrBloom)->p1 = 10`,
which keeps the OP_Blob and only shrinks it. I restored the pre-fix code:
noop the OP_Blob that initializes the Bloom filter register, and otherwise
set OP_Once.p3 to the Bloom register (the old redundant `else`). The
comment-only hunks (vdbe.c, expr.c tag comments) are not behavioral, so
nothing to revert.

The register is then never initialized as a blob, but other code (e.g. a
compound-select subquery path that still reaches OP_Filter/OP_FilterAdd on
that register) asserts `MEM_Blob`.

## Oracle failures
bloom1-6.1 (the case added by the fix) fails: `sqlite3VdbeExec: Assertion
`pIn1->flags & MEM_Blob' failed`, crashing the run, so bloom1-7.1..7.6 also
do not complete.
