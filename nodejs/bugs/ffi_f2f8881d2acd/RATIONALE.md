# Re-introduced bug: FFI function signatures evaluated twice

Native code reads the user-supplied signature (`arguments`/`return`) when creating the raw function; the JS wrapper in lib/ffi.js then read the signature again (via getters/proxies/mutation), so the native and JS signatures could differ (e.g. native sees 8 args, wrapper sees 1).

## Changes (all in lib/ffi.js)
- `wrapFFIFunction(rawFn, owner)` -> `wrapFFIFunction(rawFn, argumentTypes, returnType, owner)`; metadata from `kSbArguments`/`kFastArguments`/`kSbReturn` is only used when argumentTypes is undefined. Reverses the fix's signature/metadata hunk (adapted to today's caching code).
- `getFunction` passes `signature.arguments` / `signature.return` (second read). Reverses the getFunction hunk.
- `getFunctions` re-reads `definitions[name]` and its `.arguments`/`.return`. Reverses the getFunctions hunk.
- `functions` getter passes `undefined, undefined` (matches the old call).

## Failing test
ffi/test-ffi-dynamic-library: `TypeError: Invalid argument count: expected 1, got 8` (the "evaluates function signatures once" subtest; the wrapper uses the second read's 1-arg signature). Stable over two runs.
