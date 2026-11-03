`repro.go` runs `for i := int8(0); i <= 120; i += 10 { arr[i] = int(i) }` over a `[128]int`.
In Go, i wraps from 120 to -126, so the correct program panics with an index-out-of-range error.
The buggy loopbce overflow check (`addWillOverflow` with int64 limits) treats the int8 loop as non-overflowing.
That removes the bounds check, so the buggy toolchain writes out of bounds (13 writes into the preceding array) and doesn't panic.
Clean prints `recovered: runtime error: index out of range [-126]`.
Buggy prints `out-of-bounds writes: 13` and `recovered: <nil>`.
