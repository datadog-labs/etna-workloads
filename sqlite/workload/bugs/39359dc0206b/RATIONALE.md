# Rationale

Fix (2008, CVS 4867): after xBestIndex, bestVirtualIndex() returned the error
"xBestIndex returned an invalid plan" if a constraint with `usable==0` had
`argvIndex>0`.

In 3.54.1 the equivalent check is in `whereLoopAddVirtualOne()` (src/where.c):
the "xBestIndex malfunction" condition includes `pIdxCons->usable==0`. I removed
that one term, so an xBestIndex that uses an unusable constraint is accepted
again and the plan is not rejected. (The test8.c hunk is test-only and is left alone.)

## Oracle failures
vtab6-11.4.1 and vtab6-11.4.2 (echo module with `echo_module_ignore_usable`)
no longer get the error from xBestIndex's invalid plan. They get
`no query solution` instead of `ab.xBestIndex malfunction`. The unusable
constraint is now used when a plan is built, and the planner finds no solution.
