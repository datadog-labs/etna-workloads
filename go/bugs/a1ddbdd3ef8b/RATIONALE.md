# Rationale

## Hunk changed
`src/cmd/compile/internal/ssa/tighten.go`: removed the check

    if opcodeTable[v.Op].nilCheck { continue }

from the canMove loop in `tighten`. This is the exact hunk of the fix (the code
around it changed slightly in go1.27.3, but the fix still applied verbatim).
Without it, nil-check values can be marked movable and tightened into a later,
conditionally executed block, so the nil check (and its panic) can be skipped.

## Oracle
`test/fixedbugs/issue72860.go` fails: `f(nil, false)` should panic on `*p`, but
the nil check is moved into the branch that is not taken, so the program prints
"should have panicked". `TestShouldTest` passes (it is not a bug oracle).
