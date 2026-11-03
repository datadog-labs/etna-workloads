# Rationale

go1.27.3 still contained the whole fix in types2 (go/types is outside src/cmd/compile and left alone). I reverted the types2 hunks of fix.patch by hand:

- assignments.go: `assignment` again rejects any generic signature with "cannot use generic function ... without instantiation in <context>" instead of calling `check.nonGeneric(newTarget(T, context), x)`, so the target type is not used for inference.
- call.go: conversion `T(arg)` calls `check.expr(nil, ...)` instead of passing `newTarget(T, "conversion")`.
- expr.go: `newTarget` uses `typ.Underlying()` instead of `commonUnder`, so type parameters with a core signature type give no target. `exprWithHint` is restored (it calls `rawExpr` with allowGeneric=false).
- literals.go: struct field values use `check.expr(nil, ...)`. Map keys and values and array/slice elements use `exprWithHint`.
- stmt.go: the send statement value uses `check.expr(nil, ...)`.

`genericExpr` keeps its `hint` parameter, because the generic call-argument path still needs it. It is unused by the reverted callers, so behaviour matches the pre-fix code.

## Oracle failures
`TestFixedbugs/issue77245.go` fails (and with it `TestFixedbugs`). Before the fix, `F(g)`, `[]F{g}`, `struct{f F}{f: g}`, `map[int]F{42: g}` and `ch <- g` with generic `g` gave "cannot use generic function g without instantiation". This applies whether F is a named func type or a type parameter with a func core type.

`TestFixedbugs/issue80042.go` also fails. I did not investigate it. It is probably another test that relies on the same inference path.
