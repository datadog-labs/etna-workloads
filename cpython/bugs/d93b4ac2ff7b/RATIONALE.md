# Rationale

Fix (gh-101162) added `"__bases__"` to `attr_exceptions` in Objects/genericaliasobject.c so `GenericAlias.__bases__` is not proxied to `__origin__`, making `issubclass(list[int], ...)` raise TypeError. (The abstract.c hunk is only a comment, nothing to revert.)

In v3.15.2 the same effect is achieved by listing `"__bases__"` in `attr_blocked` (checked first in `ga_getattro`, falls to generic getattr). I removed that entry, so `__bases__` is again proxied to the origin (e.g. `list.__bases__`), restoring the pre-fix behaviour.

Failing oracle: `test_typing.GenericTests.test_generic_subclass_checks` (3 subtests, e.g. `collections.abc.Callable[..., None]`): `issubclass(typ, object)` no longer raises TypeError.
