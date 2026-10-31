repro.py prints inspect.signature() of operator.attrgetter/itemgetter/methodcaller instances.
Clean: `(obj, /)` for each. Buggy: `(*args, **kwargs)`, because inspect no longer
uses `__text_signature__` for callable objects with `__call__`.
