from fractions import Fraction
import operator
a, b = Fraction(1, 2), 1j
for f in (operator.mod, operator.floordiv, divmod):
    for x, y in ((a, b), (b, a)):
        try:
            print(repr(f(x, y)))
        except TypeError as e:
            print("TypeError:", e)
