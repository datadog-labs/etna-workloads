# LPOS with RANK greater than matches

Changed `lposCommand` in `tree/src/t_list.c`, reversing both fix hunks:
1. Removed the `arraylen` counter (declaration and `arraylen++` before `addReplyLongLong`).
2. `setDeferredArrayLen(c, arraylenptr, arraylen)` is now `matches - rank + 1`, the pre-fix computation.

When RANK exceeds the number of matches, the deferred length is negative (e.g. `*-4`) instead of `*0`.

Oracle: "LPOS when RANK is greater than matches" fails (`LPOS ... COUNT 10 RANK 5` returns an invalid reply). The test run then aborts, so the later oracle cases in list.tcl are reported as failing too.
