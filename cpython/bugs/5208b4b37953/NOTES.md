repro.py calls math.atan2/copysign/remainder with a non-numeric first argument and a second argument whose `__float__` raises ZeroDivisionError and records that it was called.

Clean: TypeError for each function, and the second argument is never converted (prints False).
Buggy: math_2() converts both arguments before checking for errors, so the second `__float__` runs (prints True) and the error from the first conversion is replaced or overwritten (a ZeroDivisionError rather than TypeError, and a SystemError is possible).
