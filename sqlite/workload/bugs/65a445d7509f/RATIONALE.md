# Rationale

Both changes are in `ext/misc/decimal.c`. The fix's two implementation hunks still applied cleanly in intent, so I reverted each by hand.

1. `decimalNewFromText()`: removed the block that clears `sign` when every digit is zero. This reverses the fix's first hunk. Without it, `-0` and `-000.000` keep `sign=1`.
2. `decimal_cmp()`: removed the two loops that trim trailing zero fractional digits from `pA` and `pB`. I also restored the `const Decimal*` parameters and the `const Decimal *pTemp`. This reverses the fix's second hunk. Without the trimming, `1.2` and `1.2000` have different `nDigit` and `nFrac`, so they don't compare equal.

## Oracle result
`decimal-2001` fails. It checks `decimal_cmp` on `('-0','+0')`, `('-000.000','0')` and `('1.2','1.2000')`, and now returns rows instead of `{}`.

`decimal-1001` and `decimal-1041` still pass. `decimal_result` already forces the sign to 0 for zero values when it formats output, so printing hides the negative-zero bug. The bug only shows up in comparisons.
