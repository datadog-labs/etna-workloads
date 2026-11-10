# Re-introduced bug: detect-module does not retry as ESM for CJS-only errors

**Bug.** With `--experimental-detect-module`, code that is a syntax error only in CommonJS but valid in ESM is not retried as ESM. This covers top-level `await` and top-level redeclaration of `module`, `exports`, `require`, `__filename` or `__dirname`. Only the `import`, `export` and `import.meta` errors triggered a retry, so such code fails with a SyntaxError.

**Change (src/node_contextify.cc, one hunk in two parts).**
- I removed the `throws_only_in_cjs_error_messages` array. This matches the fix's added array of the same name.
- In `ShouldRetryAsESM`, I removed the loop that matched these messages and set `maybe_valid_in_esm`. This matches the fix's added retry logic, which re-parsed the code as ESM when one of those messages appeared. Without it, these errors no longer lead to an ESM compile attempt, as before the fix.
- Today's release does this retry in `ShouldRetryAsESM`, not inline in `ContainsModuleSyntax`. The later `maybe_top_level_await_errors` heuristic is left untouched because it is not part of the fix. It only covers the "missing )" and "Unexpected" messages.

**Failing tests.** `es-module/test-esm-detect-ambiguous` reports "not ok" on every run, and I ran it three times. Failing subtests include:
- `permits top-level await`: stderr is `SyntaxError: await is only valid in async functions and the top level bodies of modules`, expected empty.
- `permits top-level await above import/export syntax`: stderr is the same SyntaxError.
- `permits declaration of CommonJS module variables`: stderr is `SyntaxError: Identifier 'exports' has already been declared`, expected empty.
- the `require`/`exports` plus top-level-await cases: the new "Cannot determine intended module format" ReferenceError is expected, but a plain `SyntaxError: await is only valid...` is produced.
