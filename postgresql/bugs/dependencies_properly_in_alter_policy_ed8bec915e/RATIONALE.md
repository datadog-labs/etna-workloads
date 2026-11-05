# Rationale

File: src/backend/commands/policy.c, function AlterPolicy().

Three hunks, each tracing to a hunk of fix_impl.patch. I removed the `else` branch the fix added in each place:
1. `if (role_ids != NULL) ... else {...}`: the fix loaded the existing polroles from the catalog when ALTER POLICY did not specify roles. Without it, role_oids and nitems stay empty, so the role dependencies are recreated without the policy's existing roles.
2. `if (qual != NULL) ... else {...}`: the fix loaded the existing USING expression and built its range table. Without it, the dependencies of the existing USING expression are dropped.
3. `if (with_check_qual != NULL) ... else {...}`: the same for the WITH CHECK expression.

Together they bring back the bug. ALTER POLICY drops the dependencies of any part of the policy that the command does not change. The later dependency-recreation code only sees the new parts.

Failing oracle case: src/test/regress||rowsecurity
