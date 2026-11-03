# Rationale

Changed: `src/cmd/compile/internal/ssa/value.go`, `CanSSA`: removed the `if t.Size() == 0 { return true }` early return.
This reverses the fix's value.go hunk. The code is identical to the pre-fix function, so zero-sized types such as `[2][0]int` are again SSA-able only if they pass the size, kind and element checks.

The two ssagen/ssa.go hunks (the Fatalf in `assignWhichMayOverlap` and in `addr`) were already replaced in 1.27.3 by tolerant code. They only matter when zero-sized values are SSA-able, so I left them alone.

Oracle failures:
- issue77635.go: internal compiler error.
- issue77635b.go: `internal compiler error: 'f8': can SSA LHS .autotmp_1.t but not RHS v4` (also in f5). The LHS field is SSA-able but the zero-sized RHS value is not.
