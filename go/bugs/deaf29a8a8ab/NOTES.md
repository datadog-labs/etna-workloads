repro.go is test/fixedbugs/issue43835.go. In a function with a defer, a multi-value assignment or return such as `bad, _ = true, *p` stores into the named result before the later `*p` panics. The deferred recover then lets the function return with the early write visible.

- go-clean: exits 0.
- go-buggy: `panic: FAIL`, exit status 2. The compiler no longer treats result writes in functions with defers as order-sensitive.
