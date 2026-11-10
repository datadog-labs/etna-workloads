# Re-introduced bug: https agent.createConnection mutates caller's options

**Bug:** `agent.createConnection(port, host, options)` in lib/https.js used the caller's `options` object directly, then wrote `options.port`/`options.host` into it, so the caller's object was mutated.

**Hunk (lib/https.js, `createConnection`):** The fix added a final `else { options = { ...options }; }` branch (and copied `host` in the second branch). In today's code (`args[2]` form) the final branch is `options = { ...args[2] };`; I changed it to `options = args[2];`, restoring the pre-fix aliasing. The `args[1]` copy is left as is, since the fix's test only exercises the options-as-third-argument path.

**Failing test:** parallel/test-https-agent-create-connection ("not ok"): the new `options should not be modified` case fails with an AssertionError from `assert.deepStrictEqual(options, {port: 3000, rejectUnauthorized: false})`, because `options.port` is overwritten and `options.host` is added. Failure was stable across 2 runs.
