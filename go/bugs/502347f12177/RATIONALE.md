# Rationale

## Change
`tree/src/cmd/compile/internal/types2/typeset.go`, in `computeInterfaceTypeSet`, the `check.later` closure for duplicate embedded methods.

The fix removed the `check.pkg == m.pkg &&` guard (and its TODO comment) from the condition. I restored the guard:

    if check.pkg == m.pkg && pos.IsKnown() && !check.allowVersion(go1_14) || !Identical(m.typ, other.Type())

The condition is the same as before the fix. Only the `allowVersion` signature differs, because it has since changed to take no position argument. With the guard, the pre-go1.14 "duplicate method" error is skipped when the method comes from a different package, such as `io.Reader` with `Reader`. The fix's `go/types` hunk is not applied because the task is limited to `src/cmd/compile`.

## Oracle failures
`TestFixedbugs/issue66285.go` fails, and so does its parent `TestFixedbugs`. The expected "duplicate method Read" errors are missing for the `io.Reader` + `Reader` and `io.Reader` + `io.Reader` interfaces under go1.13.
