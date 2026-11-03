# Rationale

Fix: "[dev.simd] cmd/compile: accounts rematerialize ops's output reginfo" (#70451).

## Changed hunk
`src/cmd/compile/internal/ssa/regalloc.go`, `allocValToReg`, rematerializeable branch:
removed the block added by the fix's regalloc.go hunk (compute `sourceMask := s.regspec(c).outputs[0].regs`,
and if `mask` and `sourceMask` don't intersect, allocate a register from `sourceMask` for the
rematerialized value and wrap it in an `OpCopy`). The branch is back to just
`c = v.copyIntoWithXPos(s.curBlock, pos)`, as before the fix. The code in go1.27.3 was identical
to the fix apart from `mask.intersect(sourceMask).empty()` replacing `mask&sourceMask == 0`.

The `OwnAux: &AuxCall{}` hunk in func.go (needed by the new unit test) and the test hunks are left alone.

## Oracle
`TestRematerializeableRegCompatible` rematerializes a GP-output MOVLconst into an FP-register
use (POR); without the Copy no GP->FP move is issued, so the test reports "Expects an Copy to be issued".
Real symptom: a rematerialized GP constant is used directly in an X register, producing wrong code/illegal asm for SIMD.
