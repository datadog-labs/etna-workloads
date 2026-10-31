import math, cmath
print(math.copysign(1, math.nan), math.copysign(1, cmath.nan))
print(math.copysign(1, float('nan')), math.copysign(1, float('-nan')))
print(math.copysign(1, complex('nan').real), math.copysign(1, complex('-nan').real))
