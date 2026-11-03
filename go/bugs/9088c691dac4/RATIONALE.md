# Rationale

Hunk reversed: `src/cmd/compile/internal/ssa/regalloc.go`, the `needIntTemp` block in `regalloc`.

The fix changed `if m&^desired.avoid != 0` to `if m&^desired.avoid&^s.nospill != 0`. In go1.27.3 the same
condition is `!m.minus(desired.avoid).minus(s.nospill).empty()`. I dropped the `.minus(s.nospill)`, so the
condition is `!m.minus(desired.avoid).empty()` again.

With this change the temp register mask can be narrowed to registers that are all nospill. `allocReg` is then
called with a mask containing only nospill registers, which is the bug in #57846.

Oracle: `test/fixedbugs/issue57846.go` fails (2 of 2 cases): the compile fails in regalloc.
