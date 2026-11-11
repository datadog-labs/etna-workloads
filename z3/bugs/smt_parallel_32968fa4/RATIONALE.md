Changed hunk: src/src/util/hash.h, get_composite_hash. Traces to the hash.h hunk of FIX.diff.
The fix removed `SASSERT(n > 0)` and added `case 0: return c;`. I undid both: the assert is back and
the n==0 case is gone. A composite with zero children (e.g. the FloatingPoint sort with no
parameters in 2935.smt2) now hits the assertion violation, which is the bug in #2935.

The other FIX.diff hunks (sat_xor_finder, smt_parallel) are not reintroduced. The sat_xor_finder
check is not present in this release, and the smt_parallel changes do not affect this test.

Final ./check.sh output:
BUILD OK
FAIL z3test:smt2/2935.smt2 (rc=110)
    < sat
    > ASSERTION VIOLATION  File: .../src/util/hash.h Line: 82  n > 0
