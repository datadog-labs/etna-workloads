# Rationale

In go1.27.3 the pre-fix mechanism (OSIZEOF/OALIGNOF/OOFFSETOF ops, typecheck folding them to OLITERAL) no longer exists, so the fix hunks can't be reversed literally. Instead the fix's new `exprSizeof/Alignof/Offsetof` path is made to behave like the pre-fix one: the argument expression is fully constructed (and then discarded), which creates unused temporaries.

- `noder/writer.go` (hunk: writer `Sizeof`/`Alignof`/`Offsetof` cases): the cases now also `w.expr(expr.ArgList[0])`, writing the full argument expression, which the fix removed ("all we need to track is the argument type").
- `noder/reader.go` (hunk: reader `exprSizeof/Alignof/Offsetof`): the reader reads that argument with `r.expr()` and discards it, only then returning the uintptr literal. This is what the pre-fix code did when it built the whole argument expression and typecheck replaced it with a literal.

## Oracle
`test/fixedbugs/issue62515.go` fails: `internal compiler error: unused auto: .autotmp_6`. This is the failure described in the commit message.
