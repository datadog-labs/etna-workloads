# Rationale
File: src/backend/commands/statscmds.c, function CreateStatistics.
Traces to the fix_impl.patch hunk adding the `if (check_rights) { object_aclcheck(NamespaceRelationId, ..., ACL_CREATE) ... }` block after namestrcpy(). I removed that block, so CREATE STATISTICS no longer checks CREATE privilege on the target schema. A user without CREATE on the schema can create statistics objects in it. The `check_rights` parameter and its callers are left in place and unused; the missing check is the whole behavioral bug.

Failing oracle case: src/test/regress||stats_ext
