# Rationale

The fix changed `dictPass` in noder/stencil.go so that a type assertion from an
empty interface with a shape type uses a normal assertion, not a dynamic
(dictionary-based) one. stencil.go and the dict pass no longer exist in go1.27.3
(unified IR). The equivalent decision is in `writer.exprType`
(src/cmd/compile/internal/noder/writer.go): the reader builds an itab-style
dynamic type only when the source interface is non-empty.

Change: `if w.Bool(iface != nil && !iface.Underlying().(*types2.Interface).Empty())`
became `if w.Bool(iface != nil)`. The empty-interface exclusion is the same
check the fix added (`!IsEmptyInterface()`), so empty interfaces again take the
non-empty-interface (itab) path.

Oracle: test/typeparam/issue53762.go (`v.(int)` where `v` is `Value[T]`, an empty
interface) crashes the compiler in ssagen (`exprCheckPtr`), so both oracle
cases fail.
