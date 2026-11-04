Reproducer for the power(0, negative) bug. The statements call power/pow with a zero base and a negative float exponent.
Clean build: each statement fails with "Compute error: zero raised to a negative power is undefined".
Buggy build: the Float64/Float64 path uses plain powf, so the statements return Infinity.
