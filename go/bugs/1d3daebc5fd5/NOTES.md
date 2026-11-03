repro.go calls a generic func `f5[T any](I[T])` (I[T] is a named generic interface with method m(T))
with an unnamed interface literal `interface{ m(int); n() }` (go.dev/issue/60564).
Clean toolchain: compiles and prints "ok". Buggy toolchain: the unifier only looks at literal
interfaces, not under named ones, so it wrongly rejects the call with
"type interface{m(int); n()} of x does not match inferred type I[int] for I[T]" (exit 1).
