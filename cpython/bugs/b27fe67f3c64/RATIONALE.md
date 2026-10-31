# gh-104555 reintroduced (Lib/typing.py only)

Fix hunks reversed:
1. `_ProtocolMeta.__subclasscheck__` override that raised "Protocols with non-method
   members don't support issubclass()" before consulting ABCMeta's cache: the
   non-callable-members check is removed from it (v3.15.2 form of the hunk).
2. `_proto_hook`: the fix removed the check from the hook; here it is put back
   (pre-fix location), with `_allow_reckless_class_checks(depth=4)` to account for the
   extra `__subclasscheck__` frame. The check now runs only on an ABC cache miss, so a
   prior `isinstance()` (which caches the result) makes `issubclass()` return a value
   instead of raising TypeError.

Failing oracle cases: test_no_weird_caching_with_issubclass_after_isinstance, _2, _3,
_pep695 (TypeError not raised), plus test_protocols_issubclass_non_callable and the two
test_interaction_with_isinstance_checks_on_superclasses_with_ABCMeta cases (same cause).
