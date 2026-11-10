# Bug
With --enable-source-maps, a call site whose getTypeName() returns null (e.g. async/await in ESM) got "null." prefixed in the rewritten stack trace (`at null.Throw (...)`), so the stack didn't match the original name.

# Change
lib/internal/source_map/prepare_stack_trace.js: the fix added `typeName !== null &&` to the namePrefix check (in today's code, the `namePrefix` line in `getOriginalSymbolName`-style helper). I removed the null check: `typeName !== 'global' ? `${typeName}.` : ''`. This restores the pre-fix behaviour of emitting "null.".

# Failing test
parallel/test-source-map-enable fails ("not ok 1") in two consecutive runs: the throw-async.mjs case expects `at Throw (...throw-async.ts:4:9)` but gets `at null.Throw`.
