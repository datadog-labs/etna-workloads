# Rationale

Bug: pointer arithmetic could be scheduled before the nil check, so a nil-derived pointer could be spilled and seen by a stack scan (#63657).

Changes (both in src/cmd/compile/internal/ssagen/ssa.go), reversing the fix's ssagen hunks:
- `exprPtr`: `p = s.nilCheck(p)` -> `s.nilCheck(p)`. Users of the pointer use the original value, not the NilCheck result, so nothing orders them after the check.
- `slice` (pointer-to-array case): the OpCopy uses `v` again instead of the nil-checked `nv`.

The rest of the fix (rules, nilcheck.go, schedule.go) is still in go1.27.3 but is harmless once the SSA builder no longer consumes the NilCheck result.

Oracle: `Test/fixedbugs/issue63657.go` fails (runtime crash from the stack scan seeing a bad pointer). The ssa package tests also show unrelated failures from the sandbox environment (go.mod warning in temp dir).
