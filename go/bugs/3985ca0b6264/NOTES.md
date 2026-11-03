repro.go copies a [96]int array over an overlapping slice region, once via `*p = arrFoo(*q)` (no-op conversion around the rhs) and once via `*p = *q`, then compares the results.
Clean toolchain: both copies agree, prints "same". Buggy toolchain: the overlap check doesn't peel the OCONVNOP, so the move is treated as non-overlapping and the result differs ("differ at index ...").
