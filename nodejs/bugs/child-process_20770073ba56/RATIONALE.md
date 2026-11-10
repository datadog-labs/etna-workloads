# Re-introduced bug: spawn ignores options when args is undefined/null

**Bug:** In `normalizeSpawnArguments` (lib/child_process.js), `args === undefined` was not treated as "no args": it fell through to the `options = args` branch, so the third argument `options` was discarded (e.g. `spawn('pwd', undefined, {cwd})` ignores cwd). `null` args threw ERR_INVALID_ARG_TYPE.

**Hunk (lib/child_process.js, normalizeSpawnArguments):** corresponds to the single implementation hunk of the fix. Replaced
`else if (args == null) { args = []; } else if (typeof args !== 'object') throw ...` with the pre-fix
`else if (args !== undefined && (args === null || typeof args !== 'object')) throw ...`, so undefined goes to the `options = args` branch and null throws.

**Failing tests (stable over 2 runs):** parallel/test-child-process-spawn-typeerror (no throw expected for `spawn(cmd, null, o)`/ options ignored) and parallel/test-child-process-spawnsync-args (undefined/null args cause options such as cwd to be ignored / throw). Both reported "not ok".
