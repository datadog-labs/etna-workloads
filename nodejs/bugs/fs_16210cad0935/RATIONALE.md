# Re-introduced bug: promisified fs.readdir withFileTypes

**Bug:** `fs.promises.readdir(path, { withFileTypes: true })` passed `!!options.withTypes` (a non-existent option) to `binding.readdir`, so the binding never returned types. The result was then fed to `getDirectoryEntriesPromise` as if it held `[names, types]`, so the Dirents were wrong or the call failed.

**Hunk:** `lib/internal/fs/promises.js`, in `readdir()`. The `binding.readdir` argument `!!options.withFileTypes` is changed back to `!!options.withTypes`. This matches the fix's one implementation hunk, re-expressed for today's code, where the call is formatted differently and uses `getValidatedPath`. The `options.withFileTypes` ternary after the call is unchanged, as in the original.

**Failing test:** `parallel/test-fs-readdir-types` reports `not ok` on both runs after rebuilding. This is the promisified `fs.promises.readdir` check. Failure message: `TypeError: Cannot assign to read only property '0' of string 'empty'`.
