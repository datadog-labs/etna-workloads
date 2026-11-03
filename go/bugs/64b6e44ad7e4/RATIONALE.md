# Rationale

go1.27.3 has no stencil.go (unified IR). The equivalent of the fix lives in
`writer.itab` (src/cmd/compile/internal/noder/writer.go), which decides whether
a (typ, iface) itab must be fetched from the dictionary.

Changed: `if w.Bool(typInfo.derived || ifaceInfo.derived)` -> `if w.Bool(typInfo.derived)`.

This reverses the fix's hunks in dictPass / getInstInfo, which made a conversion
to a shaped (derived) interface type use the dictionary itab, not only conversions
whose source type has a shape. Pre-fix, only the source type was considered.

Result: for `return Some[T]{}` as `Option[T]` (concrete source, shaped iface), no
dictionary itab entry is written, and the reader falls to the static-itab path,
hitting the assertion "Option[go.shape.int] is a shape type".

Failing oracle: Test/typeparam/issue52026.go fails with
`internal compiler error: Option[go.shape.int] is a shape type`.
