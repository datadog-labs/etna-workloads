# Rationale

Fix (#41247): `exprfmt` had no case for `ODDD`, so `[...]int{...}` was printed as `[<node DDD>]int`. The fix added `case ODDD: "..."`.

In go1.27.3 the gc `fmt.go` is gone. Types2 error messages print expressions with `syntax/printer.go`, where `*ArrayType` with `Len == nil` (the `[...]T` form) prints `...` through a fallback (`var len any = _DotDotDot`).

Change (`src/cmd/compile/internal/syntax/printer.go`): `*ArrayType` now does `p.print(_Lbrack, n.Len, _Rbrack, n.Elem)`. The `...` fallback is gone, so a nil `Len` prints nothing. This is the same defect as the original: the `...` of an implicit-length array is not printed.

Oracle: `test/fixedbugs/issue41247.go` fails. The message reads `cannot use []int{…} (value of type [3]int) ...`, but the test expects `[...]int{...}`.
