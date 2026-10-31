# Rationale

The fix added explicit `length < 0` ValueError checks to `_hashlib.HASHXOF.digest/hexdigest`
in Modules/_hashopenssl.c. In v3.15.2 the same rejection is done by Argument Clinic via
`length: Py_ssize_t(allow_negative=False)`.

Change: in `tree/Modules/_hashopenssl.c`, both clinic declarations (`HASHXOF.digest`,
`HASHXOF.hexdigest`) became `length: Py_ssize_t`, and `Modules/clinic/_hashopenssl.c.h`
was regenerated (the "length cannot be negative" check disappears). This reverses the
fix's `if (length < 0) raise ValueError` hunks: negative lengths again reach
`PyBytesWriter_Create` / `PyMem_Malloc`, giving SystemError/MemoryError.

The sha3module part of the fix (Py_ssize_t signature, negative check) was left alone.

Failing oracle: test_hashlib `test_shakes_invalid_digest_length` (MemoryError / SystemError
instead of ValueError for negative sizes; 4 errors across subtests).
