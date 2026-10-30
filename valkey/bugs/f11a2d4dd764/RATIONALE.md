# Rationale

## Changed: `getKeysSubcommandImpl` in src/server.c
Reverses the fix hunk in `getKeysSubcommand` that replied with an empty array
when `getKeysFromCommand` fails for a command flagged `CMD_NO_MANDATORY_KEYS`.
The pre-fix code always replied "Invalid arguments specified for command".
In 9.0.7 the function is `getKeysSubcommandImpl` (shared by GETKEYS and
GETKEYSANDFLAGS), so the revert applies to both.

The other fix hunks (flag definition, parsing, module flag, eval command flags)
still exist in 9.0.7 (via commands.def/json) and were left alone; the flag is
simply no longer consulted by COMMAND GETKEYS, which is what the bug amounted to.

## Oracle failures
`COMMAND GETKEYS EVAL without keys` fails: `command getkeys eval "return 1" 0`
returns the error "Invalid arguments specified for command" instead of `{}`.
