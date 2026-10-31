# Rationale

Fix gh-105237 added two early-return guards to `_ProtocolMeta` in `Lib/typing.py`:
`if cls is Protocol: return type.__subclasscheck__(cls, other)` in `__subclasscheck__`,
and the matching `type.__instancecheck__` guard in `__instancecheck__`.
v3.15.2 still has both guards, in the same places, so I deleted both (the reverse of the two
`Lib/typing.py` hunks). Nothing else was changed.

With the guards gone, `issubclass(X, Protocol)` and `isinstance(X, Protocol)` go through the
generic protocol and ABC machinery again. That is the pre-fix behaviour.

Oracle failure: `test.test_typing.ProtocolTests.test_issubclass_and_isinstance_on_Protocol_itself`
fails with `TypeError: Instance and class checks can only be used with @runtime_checkable protocols`
at `assertNotIsSubclass(object, Protocol)`. Before the fix this call raised the same error, because
`Protocol` is not runtime-checkable. The `object`-is-a-subclass-of-`Protocol` result described in the
NEWS entry needs the ABC cache path, which is reached once the guard is removed and a
`@runtime_checkable` subclass exists. Only this test failed in the run.
