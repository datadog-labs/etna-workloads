repro.go calls functions that index/assign through zero-sized or nested zero-length arrays
with an out-of-range index (issue 79236) and prints the recovered panic for each.
Clean toolchain: each case panics with "index out of range". Buggy toolchain: the bounds
check on the real index is dropped/mis-checked, so some cases print "<nil>" (no panic).
