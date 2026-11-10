# Bug
`vm.SyntheticModule` accepted duplicated `exportNames` (e.g. `['x','x']`) without error, and the type-error message said "Array of strings" instead of "Array of unique strings".

# Change (lib/internal/vm/module.js, SyntheticModule constructor)
- Removed the `else { ...forEach/indexOf... throw ERR_INVALID_ARG_VALUE(..., 'is duplicated') }` duplicate check (fix hunk 2) and the now-unused imports `ArrayPrototypeForEach`, `ArrayPrototypeIndexOf`, `ERR_INVALID_ARG_VALUE` (fix hunk 1).
- Restored the message text 'Array of strings' (fix hunk 2, first part).

# Failing test
parallel/test-vm-module-basic: not ok; expected message 'The "exportNames" argument must be an Array of unique strings. Received undefined' but got '... Array of strings. ...' (the duplicate check test would also fail).
