import annotationlib
from reprlib import recursive_repr

try:
    class My:
        @recursive_repr()
        def __repr__(self, default: undefined = ...):
            return default

    ann = annotationlib.get_annotations(
        My.__repr__, format=annotationlib.Format.FORWARDREF
    )
    print({k: v.__forward_arg__ for k, v in ann.items()})
except Exception as e:
    print(type(e).__name__, e)
