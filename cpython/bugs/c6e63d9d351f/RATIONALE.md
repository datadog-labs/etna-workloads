# Rationale

Partial reintroduction of gh-134696 (hash constructors accept `data` and `string`), limited to `_md5` and `_sha1`.

## Changes (Modules/md5module.c, Modules/sha1module.c, and their regenerated Modules/clinic/*.c.h)
- Reverse the fix hunks for md5module.c and sha1module.c. The clinic signature goes back to `string: object(c_default="NULL") = b''` with no `data` and no `string as string_obj`. The `_Py_hashlib_data_argument()` call is removed from `_md5_md5_impl` and `_sha1_sha1_impl`. The clinic headers were regenerated with `Tools/clinic/clinic.py`.
- The `_Py_hashlib_data_argument` helper in hashlib.h is left in place. Other modules still use it.

## Oracle failures
`test_clinic_signature` and `test_clinic_signature_errors` fail. `md5(data=b'')` and `sha1(data=b'')` raise `TypeError: unexpected keyword argument 'data'`. The mutual-exclusion and duplicate-argument errors are also missing.
