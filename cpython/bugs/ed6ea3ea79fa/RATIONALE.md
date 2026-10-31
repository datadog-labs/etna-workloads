# Rationale (gh-113320)

All changes are in `tree/Lib/typing.py`; v3.15.2 still had the post-fix code, so the pre-fix code was restored by hand.

- `_TYPING_INTERNALS`: `__non_callable_proto_members__` renamed back to `__callable_proto_members_only__` (fix hunk 1).
- `_ProtocolMeta.__init__`: restored the eager `cls.__callable_proto_members_only__ = all(callable(getattr(cls, attr, None)) ...)`. This runs for every protocol, runtime or not, so a descriptor that raises on class access now breaks class creation (fix hunk 2).
- `_ProtocolMeta.__subclasscheck__`: condition is `not cls.__callable_proto_members_only__` again, and the non-method attribute list is recomputed with a risky `getattr` (fix hunk 3). I kept v3.15.2's current ordering of checks, including the deprecation-warning block, which came later than the fix.
- `_ProtocolMeta.__instancecheck__`: `callable(getattr(cls, attr, None))` is used again instead of the `__non_callable_proto_members__` lookup (fix hunk 4).
- `runtime_checkable`: removed the block that computed `__non_callable_proto_members__` and wrapped errors in `TypeError("Failed to determine whether protocol member ...")` (fix hunk 5).

## Oracle failures
- `test_nonruntime_protocol_interaction_with_evil_classproperty`: a non-runtime protocol with a raising descriptor now raises in `_ProtocolMeta.__init__`.
- `test_runtime_protocol_interaction_with_evil_classproperty`: the raw `CustomError` propagates instead of the `TypeError` with the "Failed to determine..." message.

Both were confirmed by `./check.sh` (2 errors, 742 tests run).
