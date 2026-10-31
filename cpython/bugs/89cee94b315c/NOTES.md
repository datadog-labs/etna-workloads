repro.py subclasses the C `_pickle.Pickler`/`Unpickler` and calls `super().persistent_id(obj)` / `super().persistent_load(pid)`.
Clean: the default methods exist (pickler dumps 'abc'; unpickler's default persistent_load raises UnpicklingError).
Buggy: the default methods are missing, so both raise AttributeError.
