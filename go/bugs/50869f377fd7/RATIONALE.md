# Rationale
Fix hunk reversed: types2/conversions.go `conversion`: the fix changed
`isInteger(x.typ) && allString(T)` to `x.mode == constant_ && isInteger(...) && allString(T)`.
In go1.27.3 the same branch exists (`x.mode() == constant_ && isInteger(x.typ()) && allString(T)`);
I removed the `x.mode() == constant_ &&` condition (and reverted the comment wording to "integer").
(go/types is generated from types2, so only types2 is in scope.)

Effect: non-constant untyped integer shifts like `string(1 << s)` keep their untyped type
instead of getting the default type/float64-style shift check, so the "shifted operand 1 must be integer" error is not reported.

Oracle failures: types2 TestCheck (shifts / issue45114 testdata) and
test/fixedbugs/bug193.go (`missing error "shift"` at line 14).
