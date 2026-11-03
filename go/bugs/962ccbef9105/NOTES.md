repro.go is upstream test issue63657.go: f(nil, ...) takes &x.b after a nil check, with a deep recursion (stack growth) in between.
Clean: the nil check panics, it is recovered, exit 0, no output.
Buggy: the address calc floats above the nil check, so a bad pointer is live across stack growth and the runtime crashes fatally (exit 2, goroutine dump).
