Reproducer for the use-after-free in `_json.c` when `BadDict.items()` returns a mutable list and the key encoder clears it mid-iteration (gh-142831).

The clean interpreter prints `('{"x": "x"}',)`. The buggy interpreter, which no longer holds a strong reference to the borrowed item tuple, segfaults (exit 139).
