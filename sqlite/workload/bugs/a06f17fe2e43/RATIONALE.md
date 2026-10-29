# Rationale

Fix (2008-05-11, tickets #3101/#3060) changed `sqlite3AtoF` so that digits
after the decimal point are only accumulated up to a bounded number of
significant digits (`nSignificant<18`); before, every fractional digit was
accumulated into the mantissa and the divisor, which overflowed for long inputs
and produced NaN/wrong values instead of exact/Inf/0.0 results.

## Change (src/util.c, `sqlite3AtoF`, fractional-digit loop)
Reverses the `if( nSignificant<18 ){...}` hunk. The 3.54.1 equivalent is the
guard `if( s<(LARGEST_UINT64-9)/10 ) {...} else mState = 11;`, which stops
accumulating digits once the u64 mantissa is full. I removed that guard so
every fractional digit is multiplied into `s` (u64 wraps) and decrements `d`,
i.e. again no limit on significant digits.

The other fix hunks (leading-zero skipping, tclsqlite test1.c bind helpers,
manifest/test files) are test-only or already naturally covered by the s==0
handling in 3.54.1, so were not reverted.

## Oracle failures (test/nan.test)
16 of 47 cases fail: nan-4.1-4.12, 4.15-4.18 (long numeric literals with
many fractional digits give wrong magnitudes, e.g. 0.0 instead of
9.88131291682493e-324, or wrong large values instead of 1e+307/inf).
