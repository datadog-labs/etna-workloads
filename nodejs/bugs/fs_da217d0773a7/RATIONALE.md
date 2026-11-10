# Rationale

**Bug:** `flag` and `mode` validation in fs was wrong. Numeric `flags` were passed through unvalidated, so an out-of-range value such as 2176057344 reached the C++ binding and crashed (nodejs/node#37430). `parseFileMode` also rejected non-string/non-number input with `ERR_INVALID_ARG_VALUE` instead of `ERR_INVALID_ARG_TYPE`.

**Hunks**
- `lib/internal/fs/utils.js` `stringToFlags`: removes `validateInt32(flags, name)` for number flags. This corresponds to the fix's `validateInt32(flags, name)` hunk. Numbers are returned unchecked again. The `name` argument and the `'options.flag'` call in `readFile` remain, but they no longer have any effect.
- `lib/internal/validators.js` `parseFileMode`: restores the old logic. That is the `isUint32` fast path, `validateInt32` only for numbers, a string path that returns early, and a final `ERR_INVALID_ARG_VALUE` throw. This corresponds to the fix's `parseFileMode` hunk. `{}`, `[]`, `false` and `null` now give `ERR_INVALID_ARG_VALUE`, and 2176057344 as flags is no longer rejected.
- I did not re-introduce the `lchmod` hunk. The current `lchmod` still has `parseFileMode`, and the `readFile` name hunk is covered above.

**Failing tests** (all five oracle cases, `not ok`):
- test-file-validate-mode-flag: out-of-range flags no longer throw `ERR_OUT_OF_RANGE`.
- test-fs-chmod, test-fs-fchmod, test-fs-open, test-process-umask: expected `ERR_INVALID_ARG_TYPE` but got `ERR_INVALID_ARG_VALUE`.
