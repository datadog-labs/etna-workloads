# gh-105144 reintroduced in Lib/typing.py

Fix hunks reversed (the fix moved the sanity checks from `_proto_hook` into `_ProtocolMeta.__subclasscheck__`):

- Removed the `_is_runtime_protocol` check and its TypeError from `_ProtocolMeta.__subclasscheck__`. This reverses the fix's added check there.
- Re-added the "sanity checks" to the top of `_proto_hook`, which is the fix's removed hunk. They are the `_is_runtime_protocol` check, which calls `_allow_reckless_class_checks(depth=3)` (the depth has to be 3 again because it is now called one frame deeper), and the arg-1-must-be-a-class check (`_type_check_issubclass_arg_1`).

Effect: the runtime-checkable check happens inside the ABC machinery. This is the original gh-105144 defect.

The oracle cases that fail are in `test_typing`, mainly `ProtocolTests.test_protocols_issubclass`. `issubclass(C, BadP)` now raises AttributeError (`__non_callable_proto_members__` missing on a non-runtime protocol) instead of the expected TypeError. Other cases that expect the specific error messages from `__subclasscheck__` also fail.
