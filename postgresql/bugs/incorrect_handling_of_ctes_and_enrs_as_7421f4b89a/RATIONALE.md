# Rationale

## src/backend/parser/parse_clause.c, setTargetTable()
Traces to the fix.patch hunk in setTargetTable. The fix replaced the
"special relations (CTE or ENR) cannot be targets" check with an ENR-only
check, because CTEs must not hide real tables when they are DML targets.
I reverted this: the check again rejects the target when the unqualified
name matches a visible CTE (scanNameSpaceForCTE) or an ENR. A DML statement
whose target table shares a name with a WITH item then wrongly fails with
"cannot be the target of a modifying statement".

The other fix hunks are refactors with no behavioral part. They are the
transformCTEReference/transformENRReference wrappers, the
getRTEForSpecialRelationTypes refactor, and the parserOpenTable ENR branch.
I left them alone.

## Failing oracle cases
src/test/regress||with fails. src/test/regress||plpgsql still passes.
