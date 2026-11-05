# Rationale

Changed: src/backend/utils/misc/guc.c, set_config_with_handle(), PGC_STRING case.

Traces to the fix_impl.patch guc.c hunk that added the "Ugly hack": when
session_authorization is set or reset, it also does SET ROLE NONE (or RESET role)
with the same context and source. I disabled that call by adding `false &&` to its
condition. The fix's other hunks are not reversed, so this is a minimal
re-expression of the bug.

With the call disabled, SET SESSION AUTHORIZATION no longer resets "role". The SQL
spec requires that it does, and the reset must have the same lifespan, for example
across rollback. The role and session user then interact incorrectly.

Failing oracle case: src/test/regress||privileges
