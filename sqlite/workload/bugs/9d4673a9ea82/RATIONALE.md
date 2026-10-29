# Ticket #1420: COUNT(DISTINCT) examines the wrong value

Fix hunk (src/select.c, updateAccumulator): `codeDistinct(v, iDistinct, addrNext, 1, 1)` became
`codeDistinct(..., 1, 2)`. The last argument told codeDistinct which stack slot held the
value being tested, and the pre-fix value of 1 pointed at the wrong slot.

In version-3.54.1 the equivalent argument is `regElem`, the register holding the DISTINCT
argument. updateAccumulator passes it as `regDistinct`. In the plain (non-ORDER BY) branch
the argument is coded into `regAgg`, and `regDistinct = regAgg`.

Change: that branch now sets `regDistinct = regAgg+1`, one register off. codeDistinct
therefore tests and inserts the wrong register, not the one just computed. This is the same
defect as the original: the distinct check looks at the wrong slot.

Oracle: test/distinctagg.test fails from distinctagg-1.1 onward. The run aborts on
`Assertion memIsValid(&aMem[pOp->p3])` in sqlite3VdbeExec, because OP_Found/OP_MakeRecord
read an uninitialised register. Without asserts it would give wrong counts.
