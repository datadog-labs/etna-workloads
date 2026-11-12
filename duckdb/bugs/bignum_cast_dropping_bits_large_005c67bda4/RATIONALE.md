# Rationale

Hunk 1 — src/function/cast/bignum_casts.cpp, `IntToBignum`: reverted the first hunk of the fix.
`CountZeros`-based byte-size computation replaced with the original `std::ceil(std::log2(abs_value + 1) / 8.0)`
(plus the UINT64_MAX special case), and `#include <cmath>` restored. log2 on a double loses precision for
large 64-bit values (e.g. 2^56 - 1 rounds up to 2^56), so one byte too many is computed
and the BIGNUM is wrong. The HugeintCastToBignum hunks were left alone (not needed for the BIGINT test).

Oracle: test/sql/types/bignum/issue25939.test — see etna-check output below.

## etna-check output
FAIL     test/sql/types/bignum/issue25939.test
         Wrong result in query! (test/sql/types/bignum/issue25939.test:5)!
         Mismatch on row 1, column count_star()(index 1)
         183 <> 0
         Actual result:
         183	72057594037927936	72057594037928118

1 of 1 oracle units fail
