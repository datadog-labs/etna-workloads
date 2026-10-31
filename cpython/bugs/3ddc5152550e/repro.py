import warnings
from _testcapi import _test_structmembersType_NewAPI as T

ts = T(False, 1, 2, 3, 4, 5, 6, 7, 8, 23, 9.99999, 10.1010101010, "hi", 12, 13, b"c")
for name in ("T_UINT", "T_ULONG"):
    for v in (-1, 2**32, 2**64 - 1):
        with warnings.catch_warnings(record=True) as w:
            warnings.simplefilter("always")
            setattr(ts, name, v)
            print(name, v, getattr(ts, name), [str(x.message) for x in w])
