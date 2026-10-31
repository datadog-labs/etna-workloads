# Rationale (gh-104263)

The fix made `float("nan")`, `math.nan`, `cmath.nan/nanj` and NaN parsing/unpacking rely on C99 `NAN`, with `fabs(Py_NAN)` forcing a positive sign. Before it, NaNs came from hard-coded bit patterns (`_Py_dg_stdnan`), and the sign of the NaN source was not normalised.

On x86-64/glibc `NAN` is already positive, so merely dropping `fabs()` is not observable here. I therefore model "NaN source with an undefined sign" by also making the generic `Py_NAN` carry a set sign bit.

Changes:
- `Modules/mathmodule.c`, `Modules/cmathmodule.c` (`math.nan`, `cmath.nan`, `cmath.nanj`): `fabs(Py_NAN)` -> `Py_NAN`. This reverses the fix's `m_nan()` -> `fabs(Py_NAN)` hunks, which guaranteed a positive sign.
- `Python/pystrtod.c` (`_Py_parse_inf_or_nan`): `fabs(Py_NAN)` -> `Py_NAN`. This reverses the sign normalisation that the fix added in place of `_Py_dg_stdnan(negate)`.
- `Include/pymath.h`: `Py_NAN` is `(-(double)NAN)`, i.e. a NaN whose sign is not positive. This stands in for the old hard-coded, platform-dependent NaN bits. The fix's pymath.h hunk documents that the sign is undefined.

Not touched: `Objects/floatobject.c` (`PyFloat_Unpack2` already differs in 3.15), and the `_Py_dg_*` removals, since the functions are gone.

## Oracle failures
Verified by `./check.sh` (the output was truncated, so only test_math was confirmed):
- `test_math.MathTests.test_nan_constant`: `copysign(1., math.nan)` is -1.0, expected 1.0.
- `test_math.MathTests.test_signbit`: `math.signbit(math.nan)` is True.

The test_cmath, test_complex and test_float failures were not checked in the output I saw.
