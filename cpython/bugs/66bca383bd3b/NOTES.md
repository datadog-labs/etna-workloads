Compares a negative non-integer float with an int subclass whose `__neg__` returns a str (gh-143006), with both having 51 bits in the integer part.
Clean: prints `False True True True False False`, exit 0.
Buggy: the injected code negates the int via `__neg__` and passes the result to `_PyLong_Lshift`. This fails `assert(PyLong_Check(a))` and aborts with exit 134.
