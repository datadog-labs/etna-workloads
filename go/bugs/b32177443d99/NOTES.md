`repro.go` calls `copy(nil, raw)` and `copy(nil, "abc")`. The first argument to `copy` must be a slice, and `nil` is not one.

- go-clean reports the compile error `invalid copy: argument must be a slice; have untyped nil`.
- go-buggy skips that check when the source is a `[]byte` or a string. It crashes with an internal compiler error: `interface conversion: syntax.Type is *types2.Basic, not *types2.Slice`.
