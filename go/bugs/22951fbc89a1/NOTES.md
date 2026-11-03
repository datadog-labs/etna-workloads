`repro.go` has a function whose body ends in `for range s {}` with no return.
Clean toolchain: compile error "missing return". Buggy toolchain: the range loop is treated as terminating, so it compiles and runs (prints 0 or misbehaves).
