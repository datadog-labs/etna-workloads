# Re-introduced bug: process.execve args not optional

**Bug:** `process.execve(execPath)` without `args` throws `ERR_INVALID_ARG_TYPE` (args must be an Array, received undefined) instead of treating omitted args as `[]`.

**Hunk:** `lib/internal/process/per_thread.js`, `execve(execPath, args = [], env = process.env)` -> `execve(execPath, args, env = process.env)`. This corresponds to the fix's single implementation hunk (which added the `= []` default; the release also has an `env = process.env` default that is kept). Without the default, `validateArray(args, 'args')` rejects undefined.

**Failing test:** parallel/test-process-execve-no-args: `TypeError [ERR_INVALID_ARG_TYPE]: The "args" argument must be an instance of Array. Received undefined`. Failed on two consecutive runs.
