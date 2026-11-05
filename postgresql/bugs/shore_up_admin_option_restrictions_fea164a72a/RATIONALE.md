# Rationale

File: src/backend/utils/adt/acl.c, function is_admin_of_role().
Traces to the fix.patch hunk in is_admin_of_role() that removed the unconditional
`member == role` fast path and replaced it with a session-user-only self-admin check
(after the superuser check). In current code that check had become "member == role -> false".
Reverted to the pre-fix behavior: `member == role` returns true before the superuser check,
so any role (e.g. via SET ROLE / security-definer / explicit grantor) can admin itself,
bringing back the ADMIN OPTION restriction hole.

Only this hunk was changed; the user.c grantor check and the pg_role_aclcheck hunk are comment-only or already restructured.

Failing oracle case: src/test/regress||privileges
