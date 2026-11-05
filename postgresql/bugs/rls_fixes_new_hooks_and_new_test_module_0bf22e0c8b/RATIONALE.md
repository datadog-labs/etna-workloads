# Rationale

Changed hunk: src/src/backend/rewrite/rowsecurity.c, get_policies_for_relation(), the
`row_security_policy_hook_restrictive` block.

Traces to the fix.patch rowsecurity.c hunks that split the single hook into
`row_security_policy_hook_permissive` (OR'd) and `row_security_policy_hook_restrictive`
(AND'd, enforced regardless of other policies). Hook-supplied restrictive policies are now
appended to `*permissive_policies` instead of `*restrictive_policies`. They get OR'd with the
permissive policies instead of AND'd, so they no longer restrict access, which brings back the
bug of hook policies not being enforced as restrictive.

Failing oracle case: src/test/modules/test_rls_hooks||test_rls_hooks
(src/test/regress||rowsecurity still passes.)
