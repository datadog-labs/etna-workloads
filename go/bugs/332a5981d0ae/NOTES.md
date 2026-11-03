repro.go is the upstream issue54467 test. It copies overlapping slices of [64]byte with copy() and via *(*[32]byte)(y[4:36]) = *(*[32]byte)(y[2:34]), then compares the results.
Clean: no output. Buggy: the array assignment uses OpMove instead of memmove, so the overlap is copied wrongly and it prints mismatches (x[20] = 18; y[20] = 16, ...).
