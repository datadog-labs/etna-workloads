# Rationale

## Change
`src/cmd/compile/internal/dwarfgen/scope.go`, `assembleScopes`: removed the
`if fnsym.Func().Text != nil` guard so `scopePCs` is called unconditionally.

This reverses the single implementation hunk of the fix (issue #44344). The
code in go1.27.3 is unchanged apart from the extra `scopeVariables` argument,
so the reversal is exact. A function whose callsites were all inlined has an
abstract DIE but no Text, so `scopePCs` dereferences a nil `p0` (`p0.Pos`).

## Oracle
`test/fixedbugs/issue44344.go` (both oracle cases) fails: the compiler panics
with a nil pointer dereference ("internal compiler error") during DWARF scope
generation. The panic also shows up while building `runtime`, so the build
fails before the test itself runs.
