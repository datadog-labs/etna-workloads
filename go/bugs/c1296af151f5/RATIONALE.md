# Rationale

Go 1.27.3 has no noder/transform.go (unified IR only). The fix's job — making sure the
CONVIFACE for the main result of a comma-ok assignment (OAS2RECV/OAS2MAPR) is created
early, with dictionary-derived runtime types, instead of late in order.as2ok — now lives
in `reader.multiExpr` (N:1 case), which assigns results to temps and builds an implicit
OCONV for lhs[0].

Change (src/cmd/compile/internal/noder/reader.go, `multiExpr`): the implicit OCONV no
longer gets `TypeWord`/`SrcRType` from `r.convRTTI(pos)` (the value is read and discarded
to keep the stream in sync). This reverses the fix's "manifest the CONVIFACE during
the transform so dictionary lookups are possible" hunk: the conversion exists but has no
dictionary-based type information for shape-typed sources.

Oracle: test/typeparam/issue50642.go fails with
`internal compiler error: incomplete itab` at the `temp2, ok = x[43]` (T Stringer -> Stringer
in OAS2MAPR). The channel case (conversion to `any`) is not reported first, as the compile aborts.
