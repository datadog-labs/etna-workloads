Starts a Thread whose callable target has `__bool__` returning False.
Clean prints `True` (target ran); buggy prints `False` because Thread.run uses `if self._target:` instead of `is not None`.
