# Rationale

Fix hunk reversed: the `etCHARX` (`%c`) case in `sqlite3VXPrintf()` (src/printf.c).
The fix replaced "render the repeated character into the fixed-size `buf[]`
(`etBUFSIZE`, 70 bytes) and set `length = precision`" with appending repeats
directly to the StrAccum. In 3.54.1 that logic was rewritten (doubling
`sqlite3StrAppend64`, UTF-8 aware), so I restored the old pre-fix code in its place:
`if( precision>=0 ){ for(idx=1; idx<precision; idx++) buf[idx]=buf[0]; length=precision; }`
then falling through to the usual width handling, as before. Precisions larger than the buffer
overflow `buf[]` on the stack. Other hunks (zExtra init, AppendSpace rename)
are refactors/not needed to cause the bug.

Oracle: printf2-3.1 aborts with "stack smashing detected" (precision 100 > 70),
killing the run, so 3.x–6.x cases don't complete.
