# Rationale
- File: src/backend/rewrite/rowsecurity.c, function get_row_security_policies().
- Traces to the fix_impl.patch hunk that added the setRuleCheckAsUser() calls (the `rewriteDefine.h` include hunk is left in place, since it's harmless). In current code the user comes from perminfo->checkAsUser.
- I removed the two calls that copy checkAsUser onto securityQuals and withCheckOptions. Subqueries inside RLS policies then run as the current user instead of the view owner when the table is reached through a view. This brings back the bug.

Failing oracle case: src/test/regress||rowsecurity
