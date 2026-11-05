# Rationale
The fix added MakeExpandedObjectReadOnly calls. Since then the executor was rewritten to use compiled expression steps, so the equivalents are EEOP_MAKE_READONLY steps. I removed them.

1. src/backend/executor/execExpr.c, ExecInitExprRec (T_CaseExpr). This traces to the fix.patch hunk in ExecEvalCase (R/O force of caseValue_datum) and the argtyplen hunks. I removed the EEOP_MAKE_READONLY step after the CASE test expression is evaluated. CaseTestExpr now reads a possibly read-write expanded datum, and functions in the WHEN clauses can modify or free it.
2. src/backend/executor/execExpr.c, ExecInitCoerceToDomain. This traces to the ExecEvalCoerceToDomain hunk. CoerceToDomainValue now reads resv/resnull directly, with no MAKE_READONLY, so CHECK expressions can get a read-write expanded pointer.
3. src/backend/utils/adt/domains.c, domain_check_input. This traces to the domains.c hunk. domainValue_datum is set to `value` without MakeExpandedObjectReadOnly.

The typcache.h and execnodes.h hunks are not needed in today's code, so I left them alone.

Failing oracle cases: src/test/regress||case, src/test/regress||plpgsql
