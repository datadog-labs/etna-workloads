repro.go is test/fixedbugs/issue52697.go: `main` has a defer and calls a function with a huge (>1GB) frame.
go-clean reports "stack frame too large (>1GB)" for both functions (exit 1).
go-buggy panics in the compiler (`dvarint: bad offset for funcdata`) because dvarint rejects offsets > 1e9.
