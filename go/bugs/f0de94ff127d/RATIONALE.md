# Rationale

Changed: `src/cmd/compile/internal/inline/inl.go`, `canInlineCallExpr`.
Removed the `if base.Debug.Checkptr != 0 && types.IsRuntimePkg(callee.Sym().Pkg) { ... return false, 0, false }` block.
This reverses the fix's inl.go hunk, which added exactly that check. The `types.IsRuntimePkg` helper and the pkgspecial.go comment are left in place because they are harmless without the check. The strings/builder.go hunk is outside src/cmd/compile, so it is not touched.

Effect: in a `-d=checkptr` build, runtime-package functions such as `internal/abi.NoEscape` are inlined into checkptr-instrumented callers and get instrumented, so checkptr fails.

Oracle: `Test/fixedbugs/issue68415.go` fails with a runtime crash (checkptr failure) from the regexp/unique program.
