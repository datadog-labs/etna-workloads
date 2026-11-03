# Rationale

Changed only `src/cmd/compile/internal/noder/reader.go`, `exprConvert` case.

The fix moved the "constant converted to type parameter is non-constant" check to
right after the source expression is read (using `typecheck.ConvertVal` on the
constant). I reversed that: the early check is removed and the check is restored at the
end of the case, applied to the already-converted node `n` and wrapping it in
`OCONVNOP` (the pre-fix code). It therefore only works when source and destination
type are identical; otherwise the OCONV from an untyped complex constant to a shape
type is built first.

(The early block in go1.27.3 also had a fallback for #79960 (string -> []byte);
removed together with the block, since the late check never needs it.)

Oracle: `test/fixedbugs/issue79812.go` fails with
`internal compiler error: 'g[float64]': weird float conversion complex128 -> go.shape.float64`.
