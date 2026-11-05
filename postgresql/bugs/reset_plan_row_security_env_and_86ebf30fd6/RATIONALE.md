# Rationale

In current code, `planUserId`/`row_security_env` became `rewriteRoleId`/`rewriteRowSecurity`.

Hunk: src/backend/utils/cache/plancache.c, `RevalidateCachedQuery`.
Traces to the fix.patch hunk "The plan is invalid ... reset row_security_env and planUserId as we're about to re-plan" (the reset on re-plan).
I removed the update of `rewriteRoleId`/`rewriteRowSecurity` after re-analysis. After a replan caused by a role change, the saved role stays stale. Switching back to the original role then looks like "no change", so the old plan is reused. That is the bug.

Failing oracle case: src/test/regress||rowsecurity
