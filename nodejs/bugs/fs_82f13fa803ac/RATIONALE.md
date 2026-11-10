# Rationale

**Bug:** `getDirents`/`getDirent` in `lib/internal/fs/utils.js` call `path.join(path, name)` to lstat entries whose type is `UV_DIRENT_UNKNOWN`. With Buffer paths or names (e.g. `readdir(Buffer, {withFileTypes: true, encoding: 'buffer'})`), `path.join` throws `ERR_INVALID_ARG_TYPE` (and in the callback path it throws synchronously instead of calling back with an error).

**Changes (all in lib/internal/fs/utils.js):**
- Removed the `join()` helper and `bufferSep` (the fix's added helper hunk).
- `getDirents`: restored `lstat(pathModule.join(path, name), ...)` and removed the try/catch around `join` (fix hunk 2).
- `getDirent` async branch: same restoration (fix hunk 3).
- `getDirent` sync branch: restored `lstatSync(pathModule.join(path, name))` (fix hunk 4).

**Failing test:** `parallel/test-fs-utils-get-dirents` fails (stable across runs): `TypeError [ERR_INVALID_ARG_TYPE]: The "path" argument must be of type string. Received an instance of Buffer` at `getDirents` (string + Buffer case).
