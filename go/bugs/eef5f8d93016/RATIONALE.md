# Rationale (issue 74836)

Fix hunk: in `regalloc`, when allocating input args, prefer SP if the arg value is already in SP and SP is allowed, so locals use SP as base.

In go1.27.3 this logic exists in two places, both in `src/cmd/compile/internal/ssa/regalloc.go`; I removed both:

1. In `regalloc()`, the input-arg loop: the `if mask.intersect(s.values[...].regs).hasReg(s.SPReg) { mask = regMaskAt(s.SPReg) }` block. This is a direct reversal of the fix hunk (adapted to the regMask API).
2. In `allocValToReg`, the "Prefer the stack pointer if it is allowed" override of `r` after `pickReg`. This is a later, separate path covering the same case (same defect: SP-based local references must use SP). Removing only (1) left the oracle passing.

Result: `check.sh` reports both oracle cases failing; building the runtime fails with the assembler error "invalid instruction ... MOVQ runtime..autotmp_N+off(DX), AX": a local accessed via a non-SP base register, which is what issue 74836 describes.
