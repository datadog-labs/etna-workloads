repro.go assigns a value of type parameter P (constraint ~*T) to a variable of type *T, which is valid Go.
Clean toolchain compiles and runs it (prints "ok"). The buggy toolchain returns early in
assignableTo (types2/operand.go) and rejects it with a bogus "P does not implement *T" compile error.
