# Re-introduced bug: segment deprecation warning for `imports` field (DEP0166)

**Bug:** `emitInvalidSegmentDeprecation` in `lib/internal/modules/esm/resolve.js` always said the warning came from the "exports" field (even for `imports` / `#specifier` resolution), and decided "double slash" vs "leading or trailing slash" by inspecting only the resolved target, never the request.

**Hunks (all in resolve.js, reverting the fix's hunks):**
1. Signature: dropped `internal` and `isTarget` params (fix hunk 1).
2. `double` regex test runs on `target` instead of `isTarget ? target : request` (fix hunk 1); a request like `#subpath/as//df.asdf` is no longer classed as double slash.
3. Message hard-codes `"exports"` instead of `internal ? 'imports' : 'exports'` (fix hunk 1).
4. Two call sites no longer pass `internal` and `true`/`false` (fix hunks 2 and 3).

**Failing test:** `es-module/test-esm-imports-deprecations` (`not ok`): warning text no longer matches the expected sequence (e.g. wrong "double slash" classification for the request-side case). `test-esm-imports` still passes.
