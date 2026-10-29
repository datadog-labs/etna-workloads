# Rationale

Fix: min()/max() were registered via WAGGREGATE with a dedicated xValue (`minMaxValue`) that returns the
current result without releasing the accumulator. Before the fix, the window-function xValue was
`minMaxFinalize`, which calls sqlite3VdbeMemRelease on the accumulator.

Change (src/func.c, min/max entries in sqlite3RegisterBuiltinFunctions): pass `minMaxFinalize` instead of
`minMaxValue` as xValue for both min and max. This reverses the fix's `minMaxValueFinalize(bValue)` / `minMaxValue`
hunk (still present in 3.54.1, now unused) and the WAGGREGATE registration hunk. The `argv[0]`->`pArg` hunk is
behaviourally equivalent and was not reverted.

Effect: calling xValue frees the accumulated value, so later rows in a window frame see an empty/garbage accumulator.

Oracle: window1-9.1.1 fails with assertion `pKey1 && pKey2` in sqlite3BinaryCompare (testfixture aborts),
so 9.1.x and later cases do not complete.
