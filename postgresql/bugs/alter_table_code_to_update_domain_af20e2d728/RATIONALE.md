# Rationale

## src/backend/commands/tablecmds.c, ATPostAlterTypeCleanup()
Traces to the fix_impl.patch hunk at `@@ -9616,7 +9627,15 @@` (ATPostAlterTypeCleanup). The fix made the code
handle domain constraints, whose `conrelid` is invalid, by finding the relation through the domain's base
type (`get_typ_typrelid(getBaseType(con->contypid))`). I restored the old `relid = con->conrelid;`.
A domain constraint that depends on a changed column of a composite type then gets an invalid relid, so
ALTER TABLE no longer updates it properly.

Only this hunk was reverted. The rest of the fix is still in place: the AT_ReAddDomainConstraint handling,
the ALTER DOMAIN output in ruleutils, and the comment rebuild.

## Failing oracle cases
- src/test/regress||domain
