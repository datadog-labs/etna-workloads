# Rationale

## Changed hunk
- File: src/backend/executor/functions.c, function `check_sql_stmt_retval` (the body that used to live in `check_sql_fn_retval`).
- Traces to the fix.patch hunk that removes `AssertArg(!IsPolymorphicType(rettype));` from `check_sql_fn_retval`.
- Change: re-added `Assert(!IsPolymorphicType(rettype));` after the local declarations. `AssertArg` no longer exists, so I used `Assert`.
- Why it restores the bug: polymorphic SQL functions can legitimately reach this check with a polymorphic rettype. The assertion is therefore wrong, and it fires in assert-enabled builds.

## Failing oracle cases
- src/test/regress||plpgsql
- src/test/regress||polymorphism
