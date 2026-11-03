# Rationale

Fix hunk reversed (src/cmd/compile/internal/noder/reader.go): the fix added `case pkgbits.TypeUnion: return r.unionType()` to `reader.doTyp` plus the `unionType` method. In go1.27.3 that method folds unions to `any`. I removed both the case and the method, so the reader again has no handling for `TypeUnion` and falls into the `default` panic. The writer still emits `TypeUnion` for `interface{ any | int }`, which is the pre-fix state.

Oracle: `Test/typeparam/issue52124.go` fails with `internal compiler error: panic: unexpected type: 10`. `TestShouldTest` passes.
