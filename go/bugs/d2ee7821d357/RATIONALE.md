# Rationale

Fix: go/types, types2 — don't panic during interface completion (#61737). Only the types2 half applies in `src/cmd/compile/`.

Changed `src/cmd/compile/internal/types2/typeset.go` (`computeInterfaceTypeSet`), reversing the fix's typeset.go hunks:
- Restored the `fmt` import and the `todo []*Func` slice.
- `explicit` duplicate-method case: with `check == nil`, panic again instead of silently ignoring.
- Embedded duplicate case: with `check == nil`, append to `todo` again; otherwise `check.later(...)` as before.
- Restored the "process todo's" loop after the embedded elements, which panics if the duplicate method signatures are not identical.

Each is the pre-fix code, restored in place of the post-fix `if check != nil` guards.

Oracle: `TestIssue61737` panics ("duplicate method M") when `NumMethods()` completes an interface built via the API with duplicate methods. The panic aborts the test binary, so the other types2 cases in the package are reported as failing too.
