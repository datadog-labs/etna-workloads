# Rationale

Fix 5b9207ff67bd added, in stencil.go `getInstantiation`, an early return when `sym.Def != nil`
(a shape instantiation already imported for inlining) so it is not regenerated, which would give
duplicate definitions of the symbol (#50121). stencil.go no longer exists; with unified IR the same
check lives in `pkgReader.objIdxMayFail` (src/cmd/compile/internal/noder/reader.go):
`if !sym.IsBlank() && sym.Def != nil { return sym.Def }`.

Change: that early return is now skipped for shaped objects (`&& !dict.shaped`), so an already-imported
shape instantiation is re-read and re-created, hitting "already have a definition for X[go.shape.T]".

Oracle: test/typeparam/issue50121.go (both cases) fail: the compiler ICEs with
"already have a definition for ...[go.shape...]". The bug also breaks std package builds,
so the whole testdir build fails.
