# Rationale

Only `Modules/resource.c` changed (reverting the fix's `resource.c` hunks; the clinic header hunks are cosmetic).

- `py2rlim()` reverses the hunk that added `py2rlim`/`PyLong_AsNativeBytes` conversion. It is back to the old
  `PyLong_AsLongLong` + cast to `rlim_t`. Large values (>= 2**63) now raise OverflowError in `setrlimit`,
  and negative values are silently accepted instead of raising ValueError (the DeprecationWarning path
  v3.15.2 added on top of the fix is gone with it).
- `rlim2py()` reverses the `rlim2py`/`rlimit2py` hunk: values are converted via `(long long)` cast, so
  large limits and `RLIM_INFINITY` come back negative, as before the fix (also affects `RLIM_INFINITY`,
  `RLIM_SAVED_*`, which use the same helper).

Failing oracle cases: `test_contants` (RLIM_INFINITY is -1, not > 0), `test_fsize_not_too_big`
(getrlimit returns a limit of -1 instead of the large positive value), plus further failures/errors
in the `test_resource` run (3 failures, 1 error in total), e.g. `test_fsize_negative` / `test_args` style checks
for negative/huge values.
