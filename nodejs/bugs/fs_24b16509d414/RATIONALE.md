# Rationale

**Bug:** `fs.cp` / `fs.promises.cp` with `recursive: true, errorOnExist: true, force: false` did not
raise `ERR_FS_CP_EEXIST` when the destination *directory* already existed (and its contents did not
conflict); it silently merged the source into it. Only per-file conflicts raised errors.

**Change (lib/internal/fs/cp/cp.js, `onDir`):** removed the
`if (opts.errorOnExist && !opts.force) throw new ERR_FS_CP_EEXIST(...)` block that the fix added
after the `!destStat` mkdir branch. This matches the single implementation hunk of the fix (in the
current code `onDir` is already `async` and awaits `copyDir`, so only the guard needed removing).
Without it, an existing destination goes straight to `copyDir`, the pre-fix behaviour.

**Failing test:** `parallel/test-fs-cp-async-dir-exists-error-on-exist` — "not ok", fails with
`TypeError: Cannot read properties of null (reading 'code')` because the cp callback receives
`err === null` instead of an `ERR_FS_CP_EEXIST` error. Stable across repeated runs.
