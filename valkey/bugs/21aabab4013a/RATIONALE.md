# Rationale

Hunk reversed: `src/acl.c`, ACL DRYRUN handler (fix hunk changed `c->cmd->fullname` to `cmd->fullname`).
In 9.0.7 the message is built by `getAclErrorMessage(result, u, cmd, ...)`, which prints `cmd->fullname`.
The DRYRUN call site now passes `c->cmd` (the running `acl|dryrun` command) instead of the tested `cmd`,
so the denied-command error names `acl|dryrun` rather than the tested command. This is the same defect.

Oracle failure: `Test various commands for command permissions` fails with
"User command-test has no permissions to run the 'acl|dryrun' command" instead of naming 'set'.
