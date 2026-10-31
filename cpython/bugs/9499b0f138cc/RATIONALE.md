# Rationale

Fix hunk reversed: in `_ProtocolMeta.__subclasscheck__` (Lib/typing.py), the fix added
`and cls.__dict__.get("__subclasshook__") is _proto_hook` to the non-callable-members check, so that a
protocol with a custom `__subclasshook__` doesn't raise. In v3.15.2 the condition is the same shape
(with `__non_callable_proto_members__`); I removed the `__subclasshook__ is _proto_hook` clause, restoring the
pre-fix behaviour: any runtime protocol with non-method members raises TypeError on issubclass(),
even with a custom `__subclasshook__`.

Other fix hunks (moving `_proto_hook` to module level, `isinstance` check placement) are
refactors that don't affect the behaviour here and were left unchanged.

Failing oracle case: `test_typing ... test_custom_subclasshook_2` fails with
`TypeError: Protocols with non-method members don't support issubclass()`.
