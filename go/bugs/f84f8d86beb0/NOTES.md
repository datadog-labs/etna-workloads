Reproducer: repro.go (the upstream issue76709 test). Prove pass wrongly infers bounds for `K - len(s)` as if it were `len(s) - K`, so `len(a)-i` comparisons/divisions are miscompiled.
Clean: exits 0. Buggy: panics with "bug1: got 2, want 1" or "bug2: got ..., want -2".
