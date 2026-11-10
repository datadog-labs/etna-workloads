# CVE-2023-30584: fs path traversal bypass in the permission model

**Bug.** Absolute paths were not normalized before the permission check, so `allowed/../file.md` was still an absolute path and matched the granted prefix `allowed/*`. Reads and writes outside the allowed directory therefore succeeded.

**Where the change goes.** In v26.13.0 the JS-side `possiblyTransformPath` and the `isAbsolute` branch in `permission.js` are gone. Resolution now happens in C++. The fix's hunks that made JS resolve every string path (`lib/internal/fs/utils.js`, `lib/internal/process/permission.js`) map to `is_tree_granted` in `src/permission/fs_permission.cc`.

**Hunk (`src/permission/fs_permission.cc`, `is_tree_granted`).**
- It corresponds to both fix hunks, which dropped the `!isAbsolute(...)` guard.
- Before the fix, only relative paths were resolved. This change restores that: absolute paths skip `PathResolve` and go to the radix tree lookup unnormalized.
- `..` segments in absolute paths are therefore never collapsed.

**Failing test.** `parallel/test-permission-fs-traversal-path` fails on both runs. The child process fails with `AssertionError [ERR_ASSERTION]: Missing expected exception`, because `fs.writeFile` and `fs.readFile` on the traversal path no longer throw `ERR_ACCESS_DENIED`. `parallel/test-cli-permission-deny-fs` still passes.
