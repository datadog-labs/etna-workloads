# Bug
REPL `require('<Tab>')` / `import('<Tab>')` completion omitted builtin modules whose names contain a slash (e.g. `fs/promises`, `path/posix`, `stream/web`), because the builtin list was filtered with `!includes('/')`.

# Change
`lib/internal/repl/utils.js` (the code moved from lib/repl.js): the `_builtinLibs` filter regained `&& !StringPrototypeIncludes(e, '/')` (plus the primordial import). Corresponds to the fix's `lib/repl.js` hunk at `_builtinLibs`, which removed that clause. The other fix hunks (restructuring so builtins are offered even without allowBlockingCompletions) are already-different in today's code and were not re-introduced, to stay minimal.

# Failing tests
parallel/test-repl-tab-complete-import fails (not ok): the expected completions (publicModules, which include slash modules) differ from the actual ones lacking e.g. `fs/promises`. Stable over 2 runs.
