# Rationale

Hunk reversed: Lib/typing.py `_proto_hook` (fix hunk in `Lib/typing.py`).
The fix replaced `getattr(base, '__annotations__', {})` with
`annotationlib.get_annotations(base, format=FORWARDREF)`. In v3.15.2 the code
tries `base.__annotations__` and falls back to FORWARDREF on any exception.
I restored the pre-fix code: a plain `getattr(base, '__annotations__', {})`
(only AttributeError is caught), then the Mapping / membership / sub-protocol
check. With deferred annotations that reference undefined names, the eager
access raises NameError out of issubclass/isinstance.

Oracle failure: `test_isinstance_with_deferred_evaluation_of_annotations`
fails with `NameError: name 'undefined' is not defined`.
