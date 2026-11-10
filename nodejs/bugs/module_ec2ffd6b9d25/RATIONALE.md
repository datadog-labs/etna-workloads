# Bug
Self-referential package resolution (`require('<own package name>')` via package `exports`) did not work from the REPL or from `-r` preloaded code, because self resolution was only attempted when the parent module had a `filename`. REPL (`<repl>`) and `internal/preload` parents have none, so they fell through to a normal lookup and failed with MODULE_NOT_FOUND.

# Change
One hunk in `lib/internal/modules/cjs/loader.js` (`Module._resolveFilename`): the self-resolution call is now `parent?.filename ? trySelf(parentPath, request, conditions) : false`.
It corresponds to the fix's `_resolveFilename` hunk, which moved self resolution out of the `filename`-gated block and fed it `trySelfParentPath(parent)` (cwd for `<repl>`/`internal/preload`). The gate restores the old behaviour of resolving only when `parent.filename` exists. `trySelfParentPath` is left intact because the release also uses it for `#imports`, and the fix's other hunks (ESM cycle-avoidance requires) have no equivalent defect to restore.

# Failing tests (stable across 2 runs)
- parallel/test-preload-self-referential: `-r self_ref` fails (the child exits with an error).
- parallel/test-repl-require-self-referential: the REPL `require("self_ref")` throws MODULE_NOT_FOUND, so the output doesn't match `'Self resolution working'`.
