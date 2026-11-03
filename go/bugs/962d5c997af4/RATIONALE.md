# Rationale

Fix hunks: typecheck/func.go (old typechecker), types2/builtins.go, go/types/builtins.go.
In go1.27.3 the old typechecker is gone and go/types is outside src/cmd/compile, so the only
live equivalent is types2/builtins.go.

Changed: `src/cmd/compile/internal/types2/builtins.go`: removed
`check.verifyVersionf(call.Fun, go1_17, "unsafe.Add")` in `case _Add` and the same call for
`unsafe.Slice` in `case _Slice`. These are today's form of the fix's
`if !check.allowVersion(check.pkg, 1, 17) { error; return }` checks.

Oracle: test/fixedbugs/issue46525.go (`-lang=go1.16`) fails with "compilation succeeded
unexpectedly": unsafe.Add/unsafe.Slice are accepted under go1.16 again.
