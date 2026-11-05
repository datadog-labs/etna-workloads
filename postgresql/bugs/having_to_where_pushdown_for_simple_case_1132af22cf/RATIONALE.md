# Rationale

File/function: src/backend/optimizer/util/clauses.c, grouping_conflict_walker() (CaseExpr branch).
Traces to the fix.patch hunk adding the simple-CASE (CaseExpr with non-NULL arg) handling to the
HAVING collation-conflict walker (now living in clauses.c). The fix checks the GROUP Var at the CASE arg
against each WHEN's inputcollid. I removed that check (the foreach over cexpr->args comparing
exprInputCollation to var->varcollid), so a direct Var arg is treated as handled. A HAVING with
`CASE x WHEN ... ` using a different collation than a nondeterministic GROUP BY collation is no longer
flagged as a conflict and is wrongly pushed to WHERE.

Failing oracle case: src/test/regress||collate.icu.utf8
