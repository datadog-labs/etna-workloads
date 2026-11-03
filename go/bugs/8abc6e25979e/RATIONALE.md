# Rationale

Changed: `tree/src/cmd/compile/internal/types2/builtins.go`, `_Max, _Min` case.

Reverses the types2 hunk of fix.patch: removed the `check.assignment(x, &emptyInterface, "argument to built-in "+bin.name)` call (and its invalid-check/return) that runs when the result is not constant. The code is otherwise identical to the pre-fix state, so a non-constant untyped result such as `min(1 << s)` is no longer converted to a typed value. The go/types hunk is not applicable, since only src/cmd/compile may change.

Oracle: `TestFixedbugs/issue61486.go` fails, and the checker crashes with a panic on the untyped value. Many other `TestFixedbugs` and `TestCheck` cases in the same package also fail because of the crash.
