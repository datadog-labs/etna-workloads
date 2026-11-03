repro.go is test/fixedbugs/issue49145.go: a function with a labeled switch (`break loop`) is inlined into a loop with the same label name.
Clean prints 0,2,3 and exits 0. The buggy toolchain loses the switch label (reader.go passes nil to switchStmt), so the compiler panics with a nil pointer dereference in ssagen (Block.AddEdgeTo) and the build fails.
Note: a warm shared build cache can mask the difference; it shows up reliably with a fresh GOCACHE.
