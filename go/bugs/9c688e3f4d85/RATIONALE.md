# Rationale

In go1.27.3 `licm.go` was redesigned: it only lifts ops marked `earlyOk` (a whitelist), so the
fix's `licm.go` hunk (`hasSideEffects` => loopDependent) has no counterpart to revert, and the
fix's `hasSideEffects: true` on the divide ops is absent in the tree already. The bug is therefore
restored by letting licm treat amd64 divides as liftable:

1. `_gen/AMD64Ops.go` + `opGen.go`: `earlyOk: true` on DIVQ/DIVL/DIVW/DIVQU/DIVLU/DIVWU. Divides
   are again liftable out of loops, out from under their divisor==0 guard (the fix's AMD64Ops hunk
   marked exactly these ops as non-liftable).
2. `_gen/AMD64Ops.go` + `opGen.go`: `earlyOk: true` on ADDQconstflags. In the test, the divisor
   is `Select0(ADDQconstflags x -1)`; without this the flag op keeps the divide loop-dependent
   through the whitelist, so (1) alone does not reproduce. This is an extra enabling change, not
   from the fix; flag ops are pure so it is not itself wrong.

Only amd64 was touched (other arch hunks are not needed for the oracle).

## Oracle
`test/fixedbugs/issue78892.go` fails: `g(1)` runs the divide `7/(x-1)` hoisted above the
`x==1` early return, giving a divide-by-zero SIGFPE/crash instead of returning normally.
