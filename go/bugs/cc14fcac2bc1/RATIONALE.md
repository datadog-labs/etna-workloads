# Rationale

Fix: types2 "disallow type cycles through type parameter lists" (#49439).

In go1.27.3 the `inTParamList` field, the `tparCycle` detection in `validCycle` and the
`assert`/set in `collectTypeParams` all still exist. The one change is that a later commit
(go.dev/issue/68162) added `if tparCycle { return true }`, so these cycles are accepted.

## Changed hunk (src/cmd/compile/internal/types2/decl.go, validCycle)
Reverses the fix hunk that wrapped the `nval == len(cycle)` and `nval == 0 && ndef > 0`
early-return checks in `if !tparCycle { ... }`. I removed the `if tparCycle { return true }`
shortcut and restored that wrapper. A tparCycle cycle now falls through to `check.cycleError(cycle)`,
as it did right after the fix.

## Oracle failures
Cycle-through-type-parameter-list tests, for example `type T[P T[P]] struct{}`, report
"invalid recursive type" again. These include the testdata files from the fix and
test/typeparam/issue48280.go and issue48306.go, where `type I[T I[T]] interface{...}` is
rejected with "invalid recursive type: I refers to itself".
