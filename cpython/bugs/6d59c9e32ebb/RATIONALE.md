# Rationale

Fix hunk reversed: `Lib/typing.py`, `_ProtocolMeta.__instancecheck__` — the fix replaced
`all(hasattr(instance, attr) and (not callable(getattr(cls, attr, None)) or getattr(instance, attr) is not None) ...)`
with a loop using `inspect.getattr_static`. In v3.15.2 the loop lives at the end of
`__instancecheck__` (with `__non_callable_proto_members__` replacing the `callable(getattr(cls, attr))` test),
so I restored the `hasattr`-based `all(...)` form, keeping that modern non-callable-members condition.
Instance attribute lookups now trigger descriptors / `__getattr__` again.
(`_lazy_load_getattr_static` is left in place; it is now unused by this path.)

Oracle cases failing: `ProtocolTests.test_protocols_isinstance_attribute_access_with_side_effects`
(descriptors raising RuntimeError / `__getattr__` raising RuntimeError now propagate from isinstance())
and `ProtocolTests.test_no_weird_caching_with_issubclass_after_isinstance_3`.
