# Rationale

**Bug:** `checkIfDisallowedImport` in the resolver used to call `fileURLToPath(parsedParentURL.href)` on the parent URL unconditionally. A non-file parent such as a `data:` module that imports a `file:` URL therefore threw `ERR_INVALID_URL_SCHEME` ("must be of scheme file") instead of resolving.

**Today's code:** network imports and `checkIfDisallowedImport` no longer exist in this release. The fix's hunks that removed the eager `fileURLToPath` call can't be reversed literally. The `parentURL` handling now lives in `defaultResolve`.

**Hunk (lib/internal/modules/esm/resolve.js, `defaultResolve`):** I re-added an eager `fileURLToPath(parsedParentURL?.href)` right after the parent is parsed. This matches the removed `const parentURL = fileURLToPath(parsedParentURL?.href);` line in the fix. The three `parentURL` -> `parsedParentURL` argument hunks have no counterpart today, because the code they touched is gone.

**Failing test:** `es-module/test-esm-data-urls` fails. A `data:` module importing a `file:` URL throws `TypeError [ERR_INVALID_URL_SCHEME]: The URL must be of scheme file`. The failure was the same on two runs.
