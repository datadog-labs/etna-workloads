# Rationale

**Bug:** stream/iter Writer methods (push, broadcast, fromWritable `write`/`writev`/`end`) did not validate `options.signal`; a non-AbortSignal (e.g. `'bad'`) was silently accepted/ignored instead of throwing `ERR_INVALID_ARG_TYPE`.

**Change (lib/internal/streams/iter/utils.js, `getWriterSignal`):** corresponds to the fix's `getWriterSignal` hunk (which added `validateAbortSignal(signal, 'options.signal')`). In today's code the helper validates via `converters.WriteOptions(...)`; it is now just `return options?.signal;`, the pre-fix `options?.signal` behaviour. All callers (push, broadcast, classic) go through this helper, so the call-site hunks need no change.

**Failing test:** parallel/test-stream-iter-validation ("not ok") — the `assert.throws(() => writer.write('a', {signal:'bad'}), {code:'ERR_INVALID_ARG_TYPE'})` checks no longer throw.
