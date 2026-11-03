# Rationale

Changed only `tree/src/cmd/compile/internal/types2/builtins.go`, the `_New` case.
The fix hunk could not be reversed mechanically because go1.27.3 uses the
`x.mode()`, `x.typ()` and `x.mode_` accessors. I restored the pre-fix code
using those accessors:

- `exprOrType(x, arg, true)` replaces `false`, and the `check.exclude(x, 1<<novalue|1<<builtin)` call is removed.
- The `invalid` case is replaced by the old `builtin` case ("must be called"). Because it doesn't return, an invalid operand falls through.
- The `new(T)` case no longer calls `validVarType(arg, x.typ())`. It uses the old `T`/`isValid` check.
- In the `new(expr)` case, `verifyVersionf(call.Fun, go1_26, "new(expr)")` runs unconditionally, before any other check. This is the #75986 bug: a version error is reported even when the argument has other errors.
- Untyped args use `Default` plus `assignment(x, T, ...)`. They no longer use `assignment(x, nil, ...)`, so untyped nil isn't rejected.
- `x.typ_ = &Pointer{base: T}` replaces `NewPointer(T)`.

The `src/go/types` copy of the fix is outside the permitted scope (src/cmd/compile only), so I left it unchanged.

## Failing oracle cases
`./check.sh` reports 5 of 592 oracle cases failing: TestCheck, TestCheck/builtins0.go, TestCheck/go1_25.go, TestFixedbugs and TestFixedbugs/issue75986.go. These are the tests the fix added or changed. The go1_25 and issue75986 failures show the version error ("new(expr) requires go1.26") reported alongside other errors, or in the wrong form.
