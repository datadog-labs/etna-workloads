# Rationale

File: src/backend/optimizer/plan/initsplan.c, function deconstruct_distribute().

The fix.patch hunk 1 removed the add-back of commute_below relids to ojscope from the general non-semi join branch. Hunk 2 added it to the `JOIN_LEFT && lhs_strict` postponement branch. I reversed both. The add-back (commute_below_l and commute_below_r in today's code) now runs for every non-semi join with a SpecialJoinInfo, and it no longer runs only for postponed LEFT joins. The result is a wrong ojscope for other join types, such as FULL joins and non-lhs_strict LEFT joins. Quals then get distributed against the wrong scope.

Failing oracle case: src/test/regress||join
