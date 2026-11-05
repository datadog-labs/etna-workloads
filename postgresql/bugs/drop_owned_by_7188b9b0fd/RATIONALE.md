# Rationale

File: src/backend/catalog/pg_shdepend.c, function shdepDropOwned(), `case SHARED_DEPENDENCY_OWNER`.
Traces to the single fix.patch hunk in that function. The fix only queued an owned object for deletion if it was in the current database (`dbid == MyDatabaseId`) or was a role grant (`AuthMemRelationId`). I removed that condition, so every object with an owner dependency is queued, including shared objects such as databases in other DBs. As a result, DROP OWNED BY tries to drop a database owned by the role.

Failing oracle cases: see below.
FAIL  src/bin/scripts|t/020_createdb.pl|DROP DATABASE foobar8  ['missing']
FAIL  src/bin/scripts|t/020_createdb.pl|DROP OWNED BY role_foobar  ['missing']
