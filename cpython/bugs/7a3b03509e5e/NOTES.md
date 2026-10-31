Reproducer prints the sign bit (via math.copysign) of math.nan, cmath.nan, float('nan'/'-nan') and complex('nan'/'-nan').real.
Clean: nan constants and parsed "nan" are positive (1.0), "-nan" negative.
Buggy: Py_NAN is negative, so math.nan/cmath.nan and parsed "nan" have the sign bit set (-1.0) and "-nan" is positive.
