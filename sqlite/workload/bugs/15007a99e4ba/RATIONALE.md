# Rationale

Fix (ticket #1586) made LIMIT/OFFSET handle negative values: a negative OFFSET
is treated as 0 when computing LIMIT+OFFSET (the new `IfMemPos`/`Pop`/`Integer 0`
clamp in computeLimitRegisters). Before the fix, the negative offset was added
into LIMIT+OFFSET unclamped.

## Change
`src/vdbe.c`, OP_OffsetLimit: `sqlite3AddInt64(&x, pIn3->u.i>0?pIn3->u.i:0)`
-> `sqlite3AddInt64(&x, pIn3->u.i)`. In 3.54.1 the clamp of the offset to >=0
lives in this opcode (it replaced the removed computeLimitRegisters code), so
removing it restores the pre-fix computation. With a negative OFFSET the
combined LIMIT+OFFSET register is too small (e.g. LIMIT 5 OFFSET -2 -> 3), so
the ORDER BY sorter discards rows it should keep.

## Oracle failures
test/limit.test: limit-1.2.3 (`ORDER BY x+1 LIMIT 5 OFFSET -2`) and
limit-1.2.5 (`LIMIT -2, 5`) fail, returning 3 rows instead of 5.
