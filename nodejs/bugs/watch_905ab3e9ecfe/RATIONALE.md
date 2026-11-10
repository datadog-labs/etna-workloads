# Re-introduced bug: watch mode argument parsing

**Bug:** In watch mode the parent strips `--watch` options from `process.execArgv` before spawning the child. Before the fix, a bare `--watch` always swallowed the following argument, even when that argument was a flag. So `node --watch --inspect file.js` and `node --watch -r ./foo.js file.js` lost `--inspect`, or `-r`, in the child.

**Hunk:** `lib/internal/main/watch_mode.js`, in the `arg === '--watch'` branch. The upstream fix replaced the unconditional `i++` (taken when the arg had no `=`) with a look-ahead that keeps the next arg if it starts with `-`. In today's code that look-ahead is `nextArg && nextArg[0] !== '-'`, and `--watch=` is handled earlier. I replaced it with an unconditional `i++; continue;`, which restores the old behaviour.

**Failing tests:** `sequential/test-watch-mode` reports `not ok`. The failing subtests include `should run when --watch --inspect` (`The input did not match the regular expression /listening on ws:\/\//`). Several deepStrictEqual assertions also fail because flags that follow `--watch` are dropped. I ran the suite twice and it failed both times.
