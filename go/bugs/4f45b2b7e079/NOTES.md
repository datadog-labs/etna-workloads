repro.go is test/fixedbugs/issue72063.go (a generic Y-combinator whose closure calls f(h(h))).
Clean toolchain: compiles and runs, exit 0, no output.
Buggy toolchain: the compiler inlines the closure without end (the fix's recursive-call check is removed), so the build times out and uses a lot of memory.
