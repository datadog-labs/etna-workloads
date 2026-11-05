# Rationale

Only the gram.y hunks of fix_impl.patch apply to current code (the user.c "grantor must be current user" check no longer exists in that form, so it was not touched).

- src/backend/parser/gram.y, rule RevokeRoleStmt (both alternatives: REVOKE role FROM ... and REVOKE ADMIN OPTION FOR ...): removed `n->grantor = $5;` and `n->grantor = $8;`. Traces to the two gram.y hunks of fix.patch. The parsed GRANTED BY clause is silently ignored in REVOKE ROLE again.

Failing oracle case: src/test/regress||privileges
