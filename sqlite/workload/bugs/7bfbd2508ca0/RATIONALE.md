# Rationale

Fix hunk reversed: `whereLoopAddAll()` in src/where.c (the only implementation hunk).

The fix added the `bFirstPastRJ` flag so that the FROM term right after a
RIGHT JOIN's right operand also gets `mPrereq |= mPrior`, which stops it being
reordered with the RIGHT JOIN operand. In 3.54.1 the condition is
`bFirstPastRJ || (jointype & (JT_OUTER|JT_CROSS|JT_LTORJ))`. I changed it back
to the pre-fix form, dropping `bFirstPastRJ ||`. I also removed the variable, its
assignment (`bFirstPastRJ = (jointype & JT_RIGHT)!=0`) and the comment sentence
about it. The JT_LTORJ / hasRightCrossJoin code is later work and is untouched.
The term after a RIGHT JOIN now falls to the `else` branches, which reset
`mPrereq = 0` unless `hasRightCrossJoin` is set. That is the pre-fix behaviour.

Oracle cases that fail: join8-14000 and join8-14020. They give wrong results
for `v0 RIGHT JOIN t1 ... INNER JOIN t0` and `y0 RIGHT JOIN y1 ... INNER JOIN y2`
because the planner reorders the INNER JOIN term to the left of the RIGHT JOIN
operand. The other 107 cases pass.
