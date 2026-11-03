# Rationale

## Change
`tree/src/cmd/compile/internal/types2/expr.go`, `Checker.shift`: the bounds check
`constant.Uint64Val(yval)` is reverted to `constant.Uint64Val(y.val)`.

This reverses the second hunk of fix.patch (types2). `yval` is `constant.ToInt(y.val)`;
using the raw `y.val` means a non-Int constant shift count (e.g. a float32 constant
`s = 0`, whose value is a Float/Rat kind) is passed to Uint64Val, which then panics
or misreports instead of working on the integer-converted value. The `var yval`
declaration hoist (first hunk) is left in place since it is harmless without the use.
go/types is not part of src/cmd/compile, so it is not changed.

## Oracle failure
`TestFixedbugs/issue56425.go` (`const s float32 = 0; var _ = 0 << s`) fails with a
panic in types2 Check, matching the original bug #56425. Many other cases in the
same package fail because the panic aborts the test binary.
