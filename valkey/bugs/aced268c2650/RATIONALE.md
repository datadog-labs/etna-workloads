# Rationale

The fix (#1651) split the command name key into `fullname` (original, unchanged) and `current_name`, and gave `server.orig_commands` its own hashtable type keyed by `fullname`. The pre-fix state had one shared key field. A rename mutated it, so `orig_commands` could no longer find the renamed command.

9.0.7 already has the fix, so I restored the shared key:

- `src/server.c` `hashtableCommandGetCurrentName` now returns `command->fullname`. This reverses the `hashtableCommandGetKey` -> `GetCurrentName` split. `commandSetType` is keyed by `fullname` again.
- `src/server.c` `initServerConfig` creates `server.orig_commands` with `commandSetType`. This reverses the `originalCommandSetType` hunk. Both tables use the same key function and the same field.
- `src/config.c` `rename-command` frees and replaces `cmd->fullname` instead of `current_name`. This reverses the config.c hunk. `current_name` is kept aliased to `fullname`, so the `current_name` assignments in populateCommandTable and module.c stay harmless.

`originalCommandSetType` and `hashtableCommandGetOriginalName` are left defined but unused. The acl.c cleanup hunks were not behavioural, so I did not touch them.

## Oracle result
`./check.sh` makes the new test `ACL still denies individual renamed commands` (tests/unit/acl.tcl) fail. Renamed commands cannot be found via `orig_commands`, so ACL rules like `-ping` no longer apply. Related renamed-command ACL cases, such as `ACL GETUSER provides correct results when commands renamed`, are also affected.
