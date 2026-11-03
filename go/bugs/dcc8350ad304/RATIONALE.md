# Rationale

Fix (#47258): `noder.IncDec` gave the implicit `1` in `x++`/`x--` the operand's
type when that type was generic. Without that, the `1` was defaulted to `int`,
which breaks float/complex type parameters.

go1.27.3 has no `IncDec` helper (noder2 is gone). The equivalent is the
`stmtIncDec` case in `src/cmd/compile/internal/noder/reader.go`, which builds
the `1` with `ir.NewOne(pos, lhs.Type())`.

Change: when the operand type is a shape type (the generic case) and is not an
integer, the `1` is re-typed as plain `int`. This restores the pre-fix
behaviour, where the constant was not typed like the operand. Integer shapes
are left alone because they worked before the fix too (and std needs them).

Oracle: `test/typeparam/issue47258.go` fails with
`internal compiler error: int (INT) does not represent (1 + 0i) (Complex)`
on the `complex64` instantiation of `inc`.
