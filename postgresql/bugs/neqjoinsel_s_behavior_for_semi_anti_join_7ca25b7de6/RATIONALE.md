# Rationale

File: src/backend/utils/adt/selfuncs.c, function neqjoinsel().
Traces to the single fix.patch hunk in neqjoinsel. The fix added a JOIN_SEMI/JOIN_ANTI branch that estimates selectivity as 1 - nullfrac. I removed that branch (replaced the condition with a dead `if (false)`), so semi/anti joins again use 1 - eqjoinsel(negator). That is the old behaviour, which gives bad row estimates for != semi/anti joins, so plans in the join regression test change.

Failing oracle case: src/test/regress||join
