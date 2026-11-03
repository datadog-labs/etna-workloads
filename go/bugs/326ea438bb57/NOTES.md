repro.go is upstream test issue46725.go. It converts the result of a call returning two slices into interface values, with the second assigned to blank. With the bug, the compiler drops the liveness of the slice's backing array, so the GC finalizes s[0] early.
clean: exits 0. buggy: panics with "GC'd early" (exit 2).
