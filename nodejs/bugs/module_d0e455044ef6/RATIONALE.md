# Re-introduced bug: `--preserve-symlinks-main` ignored in `tryFile` for the main module

**Bug:** When the main entry (`argv[1]`) is a symlink given without its extension (or a directory
resolved via index.js), `Module._findPath` -> `tryExtensions`/`tryPackage` -> `tryFile(path, isMain=true)`
always resolved to the realpath, because `tryFile` only honoured `--preserve-symlinks` and only for
non-main modules. So `--preserve-symlinks-main` had no effect there and relative imports resolved
against the symlink target rather than the symlink location.

**Hunk (lib/internal/modules/cjs/loader.js, `tryFile`):** corresponds to the fix's single implementation hunk.
`getOptionValue(isMain ? '--preserve-symlinks-main' : '--preserve-symlinks')` was reverted to
`getOptionValue('--preserve-symlinks') && !isMain` (the pre-fix condition). The fix's doc-comment change was left as is.

**Failing test:** `es-module/test-esm-preserve-symlinks-main` ("not ok"): the extensionless-symlink and
directory subtests exit non-zero (submodule_link.js not found since nested/ is the realpath base).
