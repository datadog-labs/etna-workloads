repro.go calls `append(nil, s...)` with a string `s`. nil is assignable to []byte, so the
string special case accepted it without checking that the first argument is a slice.

- go-clean: compile error `invalid append: argument must be a slice; have untyped nil`.
- go-buggy: internal compiler error (assertion failed in types2/builtins.go).
