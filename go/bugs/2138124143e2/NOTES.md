repro.go uses a map literal with type-parameter key type P int|float64|complex128 and keys 1, 1.0, 1+0i.
Clean toolchain reports "duplicate key" errors (exit 1); buggy keyVal doesn't normalize numeric kinds, so it compiles and runs (exit 0).
