# Re-introduced bug: source marker lost with --enable-source-maps

**Bug.** With `--enable-source-maps`, `GetErrorSource` in `src/node_errors.cc` treated a script origin whose SourceMapUrl is an `undefined` value (non-empty handle) as having a source map. It then skipped the C++ source-line and `^` marker decoration. The JS-side `getErrorSource` returns undefined when no map is found, so nothing replaced it. Uncaught errors such as `throw {toString...}` therefore printed without the `throw ...` line and `^` marker.

**Hunks** (both in `GetErrorSource`, `src/node_errors.cc`):
1. Dropped `&& !SourceMapUrl()->IsUndefined()` from `has_source_map_url`. This reverses the fix's only hunk. On its own it no longer fails, because the current code falls through when JS adds no line.
2. When source maps are enabled and a URL is "present", return the JS result unconditionally instead of only when `*added_exception_line` is true. The old code returned `sourceline` early there, so this re-expresses that early return for today's code. It brings back the lost marker.

**Failing test.** `parallel/test-error-reporting` fails (`not ok`) on both runs. The `--enable-source-maps` throws_error7.js case's stderr no longer matches `/throw {\n\^\n{ toString: ...}/`, because the source line and marker are missing.
