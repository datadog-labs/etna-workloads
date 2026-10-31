# Rationale

Bug: gh-130317, PyFloat_Pack2/Unpack2 lose the NaN payload and sNaN/qNaN type (half precision).

Changes (all in `Objects/floatobject.c`):

- `PyFloat_Pack2`, NaN branch: reverses the fix's hunk. Instead of extracting the top 10 fraction bits of the double as the half-precision type and payload, it again emits the fixed quiet NaN (`bits = 512`). Current code also had a "set qNaN if no payload" follow-up, which is removed along with the computation.
- `PyFloat_Unpack2`, NaN branch: reverses the hunk that rebuilt the double from sign and `f << 42`. It again returns `+/-fabs(Py_NAN)`, dropping the payload.

The Pack4/Unpack4 hunks were left alone. The current code there is a rewritten form of the fix, and the oracle's half-precision failures are enough.

Failing oracle cases: `test_pack_unpack_roundtrip_for_nans` (22 subtests, size=2) fails with e.g. `b'u\xfc' != b'\x00\xfe'`, because the payload is lost on a round trip. The other oracle cases pass.
