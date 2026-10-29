# Rationale

## Change: tree/src/whereexpr.c, exprAnalyze(), virtual MATCH term for `x MATCH y` (auxiliary function constraint)
Reverses the fix's only implementation hunk, which copied the join flag onto the
newly created TK_MATCH expression when the original term came from a LEFT JOIN
ON clause. In 3.54.1 the flag is `EP_OuterON` (formerly `EP_FromJoin`) and also
carries `w.iJoin`. I removed that `if( ExprHasProperty(pExpr, EP_OuterON) ... )`
block (both the flag and the iJoin copy, since they are one unit). The virtual
term then isn't marked as from the outer join's ON clause, so the planner treats it as
an ordinary WHERE term, which is the pre-fix behaviour.

## Oracle failures
- fts3join-3.1, fts3join-3.2: "unable to use function MATCH in the requested context".
- fts3join-4.2: the plan uses vtab index 1 instead of 3 (LEFT-JOIN).
