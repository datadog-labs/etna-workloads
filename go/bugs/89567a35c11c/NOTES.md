repro.go is test/fixedbugs/issue59572.go. It assigns `fn := foo`, then ranges over a slice of funcs with `fn` as the range variable (`for _, fn = range list`) and calls `fn()`.
Clean toolchain prints 1, 2, 3. Buggy toolchain prints "foo" three times, so the range assignment to the existing variable is lost (the compiler treats fn as still holding foo).
