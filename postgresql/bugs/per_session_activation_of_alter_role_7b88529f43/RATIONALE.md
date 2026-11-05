# Rationale

Changed hunk: src/backend/utils/misc/guc.c, set_config_with_handle(), the recursive
`set_config_with_handle("role", ...)` call made when setting session_authorization.
Traces to the guc.c hunk of fix.patch. The fix passed PGC_S_DYNAMIC_DEFAULT as the source
for "role" when the original source was PGC_S_OVERRIDE (the call from InitializeSessionUserId).
Reverted: it now passes orig_source (PGC_S_OVERRIDE), so "role" is set at override priority
and ALTER ROLE/DATABASE SET role from pg_db_role_setting can no longer take effect at session start.

(The miscinit.c hunk only changed a comment, so nothing to revert.)

Failing oracle case: src/test/modules/unsafe_tests||setconfig
