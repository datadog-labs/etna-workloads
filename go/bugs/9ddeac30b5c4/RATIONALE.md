# Rationale

Fix (issue 71675) made every function calling runtime.deferrangefunc get a
deferreturn call (HasDeferRangeFunc) so recover() has a return PC even if all
returns were dead-code eliminated. In go1.27.3 the equivalent mechanism is
`isCallDeferRangeFunc` in ssagen/ssa.go `(*state).call`: it ends the block as
BlockDefer with a fake edge to the shared DeferReturn exit block, which keeps the
return block alive so genssa emits the deferreturn call.

Change: removed the `isCallDeferRangeFunc` detection and its use in the
"Finish block for defers" condition. deferrangefunc is a plain call again, so
the exit block can be eliminated and the function has no deferreturn
(runtime `recovery` throws "no deferreturn").
(Runtime hunks are outside src/cmd/compile and untouched.)

Oracle: test/fixedbugs/issue71675.go fails (runtime throw/crash on recover from
a range-over-func defer, e.g. in i() where the panic eliminates the return block).
