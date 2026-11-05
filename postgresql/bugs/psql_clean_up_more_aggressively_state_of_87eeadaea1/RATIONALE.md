Changes in src/src/bin/psql/command.c (the fix's common.c/common.h hunks are left in place; only the callers are reverted):

- exec_command_bind, exec_command_bind_named: replaced `clean_extended_state()` with `pset.bind_params = NULL; pset.stmtName = NULL;` (fix.patch command.c hunks 1 and 2). A new \bind then no longer resets send_mode or frees old state, so leftover state from an earlier \parse, \close or \bind_named leaks into the next query.
- exec_command_close, exec_command_parse: replaced `clean_extended_state()` with `pset.stmtName = NULL;` (hunks 3 and 4). send_mode and bind params are no longer cleaned when these start.

Failing oracle case: src/test/regress||psql
