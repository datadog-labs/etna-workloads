# Rationale

Fix hunks reversed (gh-128184, signatures with ForwardRefs):

1. `Lib/inspect.py` `formatannotation`: removed the
   `isinstance(annotation, ForwardRef)` branch, which is the fix's added hunk.
   ForwardRef annotations again fall through to `repr()`, giving
   `ForwardRef('undef', owner=...)` instead of `undef`.
2. `Lib/dataclasses.py` `_AutoDocstring.__get__`: `inspect.signature(cls)` is
   called without `annotation_format=FORWARDREF`, as before the fix. (The code
   moved into `_AutoDocstring` in 3.15 but is the same computation.)
   The `ForwardRef` import in inspect.py is left in place, since it is harmless.

Oracle: `test_inspect.TestSignatureObject.test_signature_str` fails
(`(x: ForwardRef('undef', owner=...))` != `(x: undef)`), plus one more
test_inspect failure from the same cause. The dataclass docstring path does
not fail in the check run, since inspect's default format handles it.
