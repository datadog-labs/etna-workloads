# Re-introduced bug: child_process accepts null bytes in arguments

Before upstream fix 91dbd8bb, child_process did not reject strings containing `\0` in command, file, args, argv0, shell, env keys/values, execPath and execArgv; they were silently truncated at the native layer. This change removes all the validation calls in lib/child_process.js.

Hunks (each is the reverse of one fix hunk, re-expressed for today's code; the helper functions `validateArgumentNullCheck`/`validateArgumentsNullCheck` are left defined but unused, as the `StringPrototypeIncludes` import is still used elsewhere):
- fork(): removed null checks of `options.execPath` and `options.execArgv`.
- normalizeExecArgs(): removed the command null check (the `validateString(command)` was kept).
- normalizeExecFileArgs() and normalizeSpawnArguments(): removed `options.argv0` checks.
- normalizeSpawnArguments(): removed checks of `file`, `args`, `options.shell`, and env key and value.

Failing test: parallel/test-child-process-reject-null-bytes ("not ok"), because the first call, `exec(... 'BBB\0XXX' ...)`, no longer throws ERR_INVALID_ARG_VALUE. Failure was stable across two runs.
