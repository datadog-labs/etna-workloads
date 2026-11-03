# Rationale

Fix hunk reversed: `noder/reader.go` `readerDict.mangle` in the fix split the `·N` vargen suffix off the name, wrote the type arguments, then re-appended the suffix (so it stays at the end for `types/fmt.go` to trim).

In go1.27.3 `mangle` (src/cmd/compile/internal/noder/reader.go) was restructured, but still does this via `n0, vsuff := SplitVargenSuffix` and `buf.WriteString(vsuff)`. I reverted it to the pre-fix behaviour: the base name is the full name (`n := n1`, which includes `·N`), type args are appended after it, and the suffix is no longer re-appended. The result is `T·1[int]` instead of `T[int]·1`. The `types/fmt.go` and `writer.go` hunks are only refactor/comments, so they are untouched.

Oracle failure: `Test/typeparam/issue54456.go` panics with `main.T·1[int]` because `reflect.TypeOf(x).String()` exposes the mangling (fmt.go only trims a trailing `·N`).
