# Rationale

## src/expr.c, gatherSelectWindowsCallback
Reverses the expr.c hunk of the fix. The fix replaced the unconditional
list-insert of each Window into `pSelect->pWin` with a call to the new
`sqlite3WindowLink()`, which only links when the window is compatible
(`sqlite3WindowCompare`) with those already linked. In 3.54.1 the resolve.c
path still goes through `sqlite3WindowLink()` (which now also handles
SF_MultiPart), so reversing that hunk alone does not bring the bug back. The
duplicated-SELECT path (gatherSelectWindows, used when a subquery is copied,
e.g. an EXISTS appearing twice or in BETWEEN) is restored to the pre-fix
inline unconditional link, so incompatible windows (e.g. MIN() OVER () and
CUME_DIST() OVER ()) end up in one scan.

The other fix hunks (new function, new assert in windowAggStep) add no
behavior, so nothing was reverted for them.

## Oracle failures
window9-6.2 (the fix's new BETWEEN test) fails with the assertion
`pWin==pMWin || sqlite3WindowCompare(pParse,pWin,pMWin,0)!=1` in
windowAggStep; the run aborts so later cases (7.x–10.x) also fail.
