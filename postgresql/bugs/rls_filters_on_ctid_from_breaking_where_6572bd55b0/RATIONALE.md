# Rationale

File: src/backend/optimizer/path/tidpath.c, function TidQualFromRestrictInfoList().
Traces to the fix.patch hunks that replaced "stop at first usable CTID qual" with a
scan of the whole rlist that prefers CurrentOfExpr (TidQualFromRestrictInfoList hunks).

Change: the loop again returns as soon as it finds any usable CTID qual (the first OR-list
or the first simple qual), instead of scanning all quals for a CurrentOfExpr. When an RLS
qual on ctid precedes WHERE CURRENT OF in the list, the CurrentOfExpr is not chosen, so the
executor fails for WHERE CURRENT OF.

Failing oracle case: src/test/regress||rowsecurity
