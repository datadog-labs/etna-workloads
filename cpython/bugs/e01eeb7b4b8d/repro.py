import statistics
from fractions import Fraction
from decimal import Decimal
for x in (23, 42.5, 1.3e15, Fraction(15, 19), Decimal('0.28')):
    r = statistics.median_grouped([x])
    print(repr(r))
