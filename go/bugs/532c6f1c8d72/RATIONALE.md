# Rationale

go1.27.3 still has objIdxMayFail/objDictIdx returning an error. The one change that
restores the bug is in `objDictIdx` (src/cmd/compile/internal/noder/reader.go): the
type-argument count mismatch check calls `base.Fatalf(...)` again instead of
`return nil, fmt.Errorf(...)`. This reverses the fix hunk
`-base.Fatalf("%v has %v+%v params...")` / `+return nil, fmt.Errorf(...)`.
Since objIdxMayFail and lookupFunction/lookupMethod only get an error from objDictIdx,
the graceful-failure path is dead and PGO LookupFunc on a function that became generic
aborts the build, as before the fix.

Failing oracle case: TestLookupFuncGeneric (the compiler crashes on MultFn[T] with
"has 0+1 params, but instantiated with 0+0 args").
