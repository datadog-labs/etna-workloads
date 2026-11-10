# Rationale

**Bug:** DEP0151 "main field extension resolution" deprecation warning was emitted for every package whose
`main` was set (and resolved via legacy main resolution) in ESM, even when `main` was a fully-specified
path (e.g. `./index.js` or an absolute path). The fix only warns if the resolved file differs from `resolve(pkgPath, main)`.

**Change** (lib/internal/modules/esm/resolve.js, `emitLegacyIndexDeprecation`): the branch
`else if (resolve(pkgPath, main) !== path)` was changed to a plain `else`. This corresponds to the fix hunk that
added the `resolve(pkgPath, main) !== path` condition (re-expressed for today's signature, which already takes
`path`/`pkgPath`); removing it restores the old unconditional warning when `main` is set. The `resolve` import is
left in place (now unused) to keep the diff minimal.

**Failing test:** es-module/test-esm-extension-lookup-deprecation — "should handle fully-specified relative/absolute
path without any warning" fails since stderr contains the DEP0151 warning instead of being ''. Verified failing on two runs.
