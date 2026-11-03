# Rationale

Fix (issue 38117): conversion of constants between int/float and complex was
rejected because constant conversions were validated with the non-constant
`convertop` rules; the fix added a `srcConstant` special case allowing any
numeric-to-numeric conversion.

In go1.27.3 the old gc `convertop` no longer exists; the types2 checker
(`src/cmd/compile/internal/types2/conversions.go`, `Checker.conversion`) handles
constants separately via `constConvertibleTo`. The change: in the
`constArg && isConstType(T)` case, a constant conversion must additionally
satisfy `x.convertibleTo(...)` (the non-constant rules), i.e. dropping the
"constants are exempt from the numeric/complex restriction" special case.

Oracle failure: test/fixedbugs/issue38117.go fails with
"cannot convert int(0) (constant (0 + 0i) of type int) to type complex64" and
the float64->complex128 equivalent (the original bug symptom).
