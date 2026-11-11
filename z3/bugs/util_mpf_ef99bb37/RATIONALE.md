# Rationale
Changed hunk: src/src/util/mpf.cpp, mpf_manager::to_sbv_mpq. Traces to the util/mpf.cpp hunks of FIX.diff.
The fix replaced the bit-by-bit shift loop (`e = exponent - sbits + 1; for (; e != 0; ++e) {div2k(z,1)...}`)
with a direct computed shift, plus `mul2k(z, exponent - sbits + 1)` in the else branch. I restored the loop.
With huge negative exponents (test: exponent = min_exp of 63 ebits) the loop runs ~2^62 iterations, so the
mpf unit hangs (killed by the 120s timeout) - the original bug (#10572-era to_sbv_mpq hang / wrong result).
(The verbose_stream debug line added by the fix is not restored; it is not part of the bug.)

Final ./check.sh output:
BUILD OK
FAIL mpf (rc=137)   (killed by timeout)
