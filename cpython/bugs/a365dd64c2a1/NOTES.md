`repro.py` copies/deep-copies an object whose `__reduce__` returns a 6-tuple (6th item = state_setter).
Clean: `copy.copy`/`copy.deepcopy` raise TypeError (`_reconstruct` takes `deepcopy` keyword-only, so the 6th item is rejected).
Buggy: `deepcopy` is positional-capable, so the 6th item is silently taken as `deepcopy` (copy ignores it / deepcopy calls state_setter), no TypeError.
