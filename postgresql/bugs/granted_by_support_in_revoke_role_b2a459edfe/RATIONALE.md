# Rationale

Changed: src/backend/parser/gram.y, rule `RevokeRoleStmt` (both alternatives).
Traces to the two gram.y hunks of fix.patch. I removed `n->grantor = $5;` and `n->grantor = $8;`, so the GRANTED BY clause is parsed but dropped in REVOKE ROLE, which is the bug the fix addressed.

The user.c hunk is not reversed. In current code GrantRole() handles grantors differently, and the grammar hunks alone reproduce the bug.

Failing oracle case: src/test/regress||privileges
