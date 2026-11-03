repro.go is upstream test issue79197.go. It assigns a zero-sized value to a[i] with i out of range (arrays of struct{}, [0]int, struct{x [0]int}) and expects an index-out-of-range panic.
Clean: the panic occurs, program exits 0. Buggy: the compiler omits the bounds check for zero-sized stores, so no panic and the program panics with "a1: no panic (bug)" (exit 2).
