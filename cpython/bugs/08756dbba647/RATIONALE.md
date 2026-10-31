# Rationale

Only `Lib/typing.py` changed.

- Fix hunk 1 (added `_ProtocolMeta.__new__` validating bases before class creation): reversed by removing `__new__`, so a bad `class Foo(Mapping, Protocol)` is created and registered with ABCMeta before the check.
- Fix hunk 2 (removed base-consistency loop from the protocol `_proto_hook`/init path): reinstated the loop in `Protocol.__init_subclass__` (where this logic lives in 3.15.2, after the `_is_protocol` early return), with the original wording/condition.

Effect: the failed class is a registered `Mapping` subclass; until gc collects it, `isinstance([], Mapping)` is True.

Oracle failure: `test_typing.ProtocolTests.test_isinstance_checks_not_at_whim_of_gc` fails with `[] is an instance of <class 'collections.abc.Mapping'>`.
