`repro.go` compiles `string(1 << s)` with a non-constant shift count `s`.
Clean toolchain: compile error (shifted operand 1 must be integer).
Buggy toolchain: the conversion keeps the untyped int type for non-constant integer-to-string conversions, so the error is missing and the program builds and runs silently.
