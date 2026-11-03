repro.go is the upstream test issue53762.go (a type assertion `v.(int)` on a generic empty-interface type `Value[T]`).
Clean toolchain compiles and runs it with exit 0 and no output. The buggy toolchain crashes the compiler with a nil pointer dereference in ssagen (dynamicDottype), because the writer emits an itab instead of an rtype for an empty interface.
