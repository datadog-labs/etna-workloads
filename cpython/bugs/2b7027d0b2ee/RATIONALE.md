# Rationale

Fix gh-104935 replaced `cls._is_protocol` / `other._is_protocol` with `getattr(..., '_is_protocol', False)`.
In v3.15.2 two of the three sites remain in the fixed form; the third (`Protocol.__init_subclass__`'s base check) is now covered by a different code path. I reverted two in `Lib/typing.py`:

1. `_proto_hook`: `getattr(other, "_is_protocol", False)` -> `other._is_protocol` (reverses the fix's first hunk). A PEP 695 generic class lacking `_is_protocol` raises AttributeError in the annotation-based member check.
2. `runtime_checkable`: `not getattr(cls, '_is_protocol', False)` -> `not cls._is_protocol` (reverses the fix's last hunk). Applying it to a non-protocol generic raises AttributeError instead of the intended TypeError.

Oracle failures (3 errors in test_typing), including `test_runtime_checkable_generic_non_protocol` (AttributeError: no attribute '_is_protocol'), plus the PEP 695 runtime-checkable tests.
