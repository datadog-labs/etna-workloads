# Rationale

Changed `src/cmd/compile/internal/syntax/parser.go` (`paramDeclOrNil`): the error for `...` without a type is
reverted from `"... is missing type"` to the pre-fix `"final argument in variadic function missing type"`.
This reverses the single implementation hunk of the fix (the message is the same code path, just moved lines).

Oracle failures: `Test/fixedbugs/bug228.go` fails (line 11 `func g(...) (...)` now reports
"final argument in variadic function missing type", which doesn't match the expected `[.][.][.]`), and the
`cmd/compile/internal/syntax` package tests fail (testdata/issue43674.go expects `... is missing type`).
