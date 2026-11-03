# Rationale

Fix: "run checkbce after fuseLate pass" (#67329).

1. `src/cmd/compile/internal/ssa/compile.go`: moved `{name: "check bce"}` back to
   just after "generic deadcode" and before "late fuse" (and before branchelim's
   position in the original; in go1.27.3 branchelim runs earlier). This reverses
   the pass-reordering hunk. Bounds checks removed by late fuse are therefore
   still reported as "Found IsInBounds".
2. `src/cmd/compile/internal/ssa/checkbce.go`: removed the `BlockInvalid` skip
   added by the fix. It was only needed once checkbce ran after fuseLate, so
   reversing it restores the pre-fix loop.

Oracle: `test/fixedbugs/issue67329.go` fails: the errorcheck test expects no
"Found IsInBounds" for `Found`'s line 12 per its annotations, but the compiler
reports it (a spurious bounds check report that late fuse eliminates).
