repro.go is test/fixedbugs/issue63490.go (minus the `// compile` line) run with `go run -trimpath`.
It stores a zero-size struct (`rf.base = r.base`) into a larger struct.
Clean toolchain: prints "Hello world", exit 0.
Buggy toolchain (Store-of-zero-size/Empty rewrite rules removed): internal compiler error
"'typesEqual': not lowered: v37, Empty STRUCT" (hit while compiling the runtime package), exit 1.
Note: the ICE is in runtime/type.go, so on the buggy toolchain the failure comes from building the runtime, not from the program itself.
