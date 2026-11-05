# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 1e9bc4074beb7678bc2fed1a104929f8e9da1615 ("psql: Fix issues with deferred errors in pipelines"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/psql/common.c

Failing oracle cases:
- `src/test/regress||psql_pipeline`
