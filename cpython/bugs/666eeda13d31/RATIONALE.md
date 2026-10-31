# Rationale

Hunk reversed: `Lib/typing.py` `_get_protocol_attrs` in the fix, which changed
`getattr(base, '__annotations__', {})` to `annotationlib.get_annotations(..., FORWARDREF)`.
In v3.15.2 the code tries `base.__annotations__` and only falls back to
`annotationlib.get_annotations(FORWARDREF)` on an exception. I restored the
pre-fix line `annotations = getattr(base, '__annotations__', {})`. `getattr`
with a default only swallows AttributeError, so a NameError raised by a deferred
`__annotate__` (unresolvable annotation) propagates and Protocol creation fails.

Oracle cases failing (2 errors in test_typing): including
`test_isinstance_with_deferred_evaluation_of_annotations` and
`test_deferred_evaluation_of_annotations`-style Protocol tests: NameError at class creation.
