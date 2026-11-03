# Rationale

Fix (#48198): the two functions that named instantiated types disagreed on byte/rune
(`byte` vs `uint8`), so one type got two names. The fix made them share one naming routine.

go1.27.3 has no `instTypeName2`/`typecheck.InstTypeName`. Instantiated names now come from
`Type.LinkString()` (fmtTypeID mode, used in noder/reader.go) and the writer emits byte/rune
as references to their universe TypeNames. The equivalent defect is that fmtTypeID stops
canonicalising the predeclared aliases.

Change: `src/cmd/compile/internal/types/fmt.go` (`typefmt`): the byte/rune/any collapse
`case fmtTypeIDName, fmtTypeID:` becomes `case fmtTypeIDName:`. Link strings then spell
`byte`/`rune` where identical types are spelled `uint8`/`int32`, so the same type gets
different names, as before the fix.

Result: check.sh fails 2 of 2 oracle cases (issue48198.go, TestShouldTest). The build of the
test binary crashes in the linker: "R_USEIFACE in testing.toOutputDir references type:rune
which is not a type or itab". That is a symbol-name mismatch for byte/rune, which is what the
fix guards against.
