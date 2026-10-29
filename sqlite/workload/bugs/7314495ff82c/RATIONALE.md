# Rationale

Fix (ticket 40812aea1fde9594): index columns of REAL affinity were made NUMERIC, so
integer constants compared against them are not lossily converted to double.

## Changes
1. `src/insert.c` (computeIndexAffStr): removed `if( aff>SQLITE_AFF_NUMERIC) aff = SQLITE_AFF_NUMERIC;`
   - reverses the insert.c hunk exactly. Index affinity string again carries REAL ('F').
2. `src/wherecode.c` (codeAllEqualityTerms and updateRangeAffinityStr): the fix's wherecode hunk
   (`REAL -> NUMERIC` in zAff) cannot be reversed because it no longer exists. Today
   `sqlite3ExprNeedsNoAffinityChange()` returns true for an integer/float literal against REAL
   affinity, which would mask removal of hunk 1 (a second path covering the same case). I
   excluded REAL from that shortcut at both call sites so OP_Affinity 'F' is again applied to
   the constant (int -> double), restoring the pre-fix behaviour.

## Oracle
`affinity2-601` fails: `SELECT 1 FROM t0 WHERE 3175546974276630385 < c0` returns no row (expected 1),
because the constant is rounded to double for the index range lookup, while 600 (plain comparison) passes.
