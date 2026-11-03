`repro.go` calls `min(1 << s)` with a non-constant shift, so the operand is untyped, and assigns the result to a float64.

- go-clean: the checker converts the untyped value to its default type (int). The compiler reports `cannot use min(1 << s) (value of type int) as float64 value in variable declaration`.
- go-buggy: the check.assignment call from the fix is missing, so the value stays untyped. The compiler crashes with an internal compiler error (assertion failed at types2/builtins.go:1135).
