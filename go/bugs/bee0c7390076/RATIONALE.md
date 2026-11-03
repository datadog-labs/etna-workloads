# Rationale

Fix (#49432): `startClosure` in stencil.go built closure formal params without `f.SetIsDDD(...)`, so the closure's type (`func([]T)`) mismatched the `func(...T)` type of its ONAME.
stencil.go no longer exists (unified IR). The equivalent closure-param builder is `syntheticSig` in `src/cmd/compile/internal/noder/reader.go`, used for method-value/wrapper closures (`methodValueWrapper`, etc.).

Change: removed `res[i].SetIsDDD(param.IsDDD())` from `syntheticSig`'s `clone`. This reverses the fix hunk's added `SetIsDDD` line in the same role (copying the "..." attribute onto closure params).

Oracle: `test/typeparam/issue49432.go` fails with
`internal compiler error: func literal (type func([]interface {})) and func(...interface {}) are not shape types`.
