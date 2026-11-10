# Re-introduced bug: findSourceMap returns null instead of undefined when not found

Bug: `findSourceMap()` (module.findSourceMap) returned `null` when no source map was found, instead of the documented/codified `undefined`.

Hunks:
1. `lib/internal/source_map/source_map_cache.js` `findSourceMap`: the not-found returns (non-string, `node:` builtin, node_modules, no cache entry, caught error) return `null` again. Corresponds to the fix's `return null` -> `return undefined` hunk (today's function has several not-found returns, all reverted); JSDoc updated to match.
2. `lib/internal/source_map/prepare_stack_trace.js` `getSourceMapErrorSource`: check `sm === null` again (fix hunk 1), needed so stack-trace code doesn't dereference null.
3. `lib/internal/errors/error_source.js`: the same `sm === undefined` check, added since the fix, reverted to `=== null` for consistency with hunk 1.

Failing test: `parallel/test-source-map-api` — `assert.strictEqual(sourceMap, undefined)` fails with `actual: null, expected: undefined`. Failure was stable across runs.
