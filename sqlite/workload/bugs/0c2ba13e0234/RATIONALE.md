# Rationale

## src/where.c, sqlite3WhereBegin (one-pass decision)
Reverses the fix's added condition
`&& (0==(wsFlags & WHERE_MULTI_OR) || (wctrlFlags & WHERE_DUPLICATES_OK))`.
The surrounding code was refactored (IsVirtual(), OptimizationEnabled) but the
condition was still present; I deleted that one line. Without it, an UPDATE
whose scan uses the OR optimization is allowed to use ONEPASS_MULTI, although
aiCurOnePass[1] isn't set accurately for such scans. The explanatory comment is
left as is.

## Oracle failures
update2-6.1 (`UPDATE d1 SET a=a+2 WHERE a>0 OR b>0`) loops forever (the run
hangs/times out there; 6.2 never runs). This is the infinite loop the fix describes.
