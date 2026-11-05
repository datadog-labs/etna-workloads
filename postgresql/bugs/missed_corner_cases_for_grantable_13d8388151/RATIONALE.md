# Rationale

Only the second corner case of the fix is re-introduced (the `validate_option_array_item()` hunks); the srole tracking is left intact.

File `src/backend/utils/misc/guc.c`, function `validate_option_array_item()`. This traces to the last two guc.c hunks of fix.patch, which add `pg_parameter_aclcheck(..., ACL_SET)` checks.
- For a placeholder (unknown) custom GUC, the check is back to `if (superuser())`. It no longer also accepts a user who holds ACL_SET.
- For a known PGC_SUSET GUC, the check is back to `gconf->context == PGC_SUSET && superuser()`.

Effect: ALTER ROLE/DATABASE ... RESET ALL, which goes through `GUCArrayReset`, skips settings the user has been granted SET on, so they are not reset.

Failing oracle case: src/test/modules/unsafe_tests||guc_privs
