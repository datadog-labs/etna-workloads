Calls statistics.median_grouped() on single-element lists of various numeric types.
Clean: always returns a float (e.g. 23.0). Buggy: returns the element unchanged (23, Fraction, Decimal).
