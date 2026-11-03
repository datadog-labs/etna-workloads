repro.go is the upstream test issue79182.go. It computes (x+x)<<31 (uint32) and (x+x)<<63 (uint64) in noinline functions.
Clean: compiles and runs, exit 0. Buggy: the amd64 rule (x+x)<<c -> x<<(c+1) lacks a bounds check on c, so the compiler fails with an internal compiler error "shift amount out of range" (exit 1).
