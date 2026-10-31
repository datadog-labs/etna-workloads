Calls inspect.unwrap on the classes `staticmethod` and `classmethod`, and on `staticmethod(classmethod)`.
Clean: each returns the class itself, so the script prints True three times.
Buggy: unwrap no longer stops at type objects, so it follows the class's `__wrapped__` descriptor and prints False three times.
