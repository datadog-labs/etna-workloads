# Rationale

Fix (#48276): after stenciling T->interface{} with T=interface{}, the OCONVIFACE
must become a no-op (OCONVNOP) because interface{}->interface{} needs no conversion.

go1.27.3 uses unified IR; stencil.go is gone. The equivalent logic is in
`src/cmd/compile/internal/noder/reader.go` (exprConvert), where a typecheck-produced
OCONVNOP between interfaces involving shape types is forced to OCONVIFACE, with an
`!n.Type().IsEmptyInterface()` guard so that empty-interface targets stay no-ops.

Change: removed that `!n.Type().IsEmptyInterface()` guard. Now an eface->eface conversion
in a shaped instantiation (e.g. IsZero[interface{}], f[interface{}]) is turned into
OCONVIFACE, which walkConvInterface rejects ("OCONVIFACE can't operate on an empty
interface") - the stenciled conversion that should be a NOP is not one.

Oracle: issue48276a.go and issue48276b.go both fail (compiler fatal error).
