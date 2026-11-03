# Rationale

Hunk changed: `src/cmd/compile/internal/types2/infer.go`, in `(*Checker).infer`.
I removed the early-exit loop over `args` that returns nil if any argument operand is invalid. This reverses the types2 hunk of the fix.
In go1.27.3 the check is written `!arg.isValid()` instead of `arg.mode == invalid`, but it is the same check.

The `go/types` hunk of the fix has no counterpart under `src/cmd/compile/`. Go/types is outside the allowed scope, so I did not touch it.

Without the check, inference continues with invalid arguments and reports extra errors such as "in call to f, type ... of ... does not match ...", on top of the original error.

Failing oracle cases (both in `cmd/compile/internal/types2`):
- `TestFixedbugs/issue60434.go`
- `TestFixedbugs` (the parent test)
