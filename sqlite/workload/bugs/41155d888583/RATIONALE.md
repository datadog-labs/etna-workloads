# Rationale

The fix (ext/misc/percentile.c, sortDoubles) replaced the pivot
`(a[0]+a[n/2]+a[n-1])/3.0` (the mean of three samples, not an element of the
array) with the median of those three samples. In 3.54.1 percentile lives in
`src/func.c` (`percentSort`), and the pivot is the middle element after a
median-of-3 prelude that puts a[0], a[n/2], a[n-1] in order.

Change (src/func.c, percentSort): for n>5 the median-of-3 prelude is skipped
and the pivot is again the arithmetic mean `(a[0]+a[n/2]+a[n-1])/3.0`; for n<=5
the existing prelude and `a[n/2]` pivot are kept (matching the old
`n>5 ? mean : a[n/2]` structure). Only replacing the pivot is not enough,
because the prelude still guarantees a[0]<=pivot<=a[n-1]; so the prelude is
dropped for n>5, as in pre-fix code that had no pre-sorting of the samples.
The partition loop assumes a[0] is below and a[n-1] above the pivot, which a
mean of unsorted samples does not guarantee.

Oracle: test/percentile.test fails at percentile-1.7.100.1 with the assertion
`iLt>0 && iLt<iGt && (unsigned)iGt<n` in percentSort (bad partition from the
mean pivot); other cases (including percentile-6.0, the median of alternating
0.1/1.0) are affected by the broken sort / assert abort.
