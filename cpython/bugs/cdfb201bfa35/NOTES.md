`repro.py` calls `issubclass`/`isinstance` with `typing.Protocol` itself as the second argument.

- clean: prints `False` for `issubclass(object, Protocol)` and the other checks. This stays true after a runtime-checkable protocol is defined.
- buggy: `issubclass(object, Protocol)` raises `TypeError: Instance and class checks can only be used with @runtime_checkable protocols`.
