repro.py wraps a function in @staticmethod and checks whether '__annotations__' is in the wrapper's __dict__ before it is accessed.
Clean: False (annotations are copied lazily on first access). Buggy: True (the injected COPY_ATTR(__annotations__) copies them eagerly when the wrapper is created).
