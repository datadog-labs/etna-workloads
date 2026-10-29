# Rationale

## Changed hunk: `src/select.c`, `updateAccumulator()`

The fix added `&& regAcc` to the condition guarding the `OP_Copy regAcc -> regHit`
("magnet" register) code for min()/max() aggregates with a FILTER clause. I removed
that condition, along with the comment the fix added to explain it. The code is
identical to the pre-fix version, apart from comment wording.

When the query has a min()/max() without a FILTER clause, `regAcc` is 0. In that case
the `OP_Copy` now copies from register 0, which is invalid and uninitialised. The
fix's guard exists to skip that copy.

## Oracle failures

- `filter1-7.1` (`SELECT max(a), max(a) FILTER (WHERE b<12345), b FROM t1;`) hits the
  assertion `memIsValid(&aMem[pOp->p1])` in `sqlite3VdbeExec`. In a non-debug build the
  `OP_Copy` would read an invalid register. All other filter1 cases pass.
