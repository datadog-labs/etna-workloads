Reproducer (repro.sh): builds the test's `issue76688` (x*y with x in [0,1], y == 1<<63) with `-d=ssa/prove/debug=1`.
Clean: no prove diagnostic (multiply by a power of two is left for a shift).
Buggy: `isPowerOfTwo(int64(umin))` treats 1<<63 as negative, so prove rewrites the Mul into a CondSelect and prints "Rewrote Mul ... into CondSelect". Generated code is the same; only the diagnostic differs.
