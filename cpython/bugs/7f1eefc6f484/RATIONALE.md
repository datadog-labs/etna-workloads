# Rationale

Hunk reversed: `Lib/unittest/mock.py`, `NonCallableMock.__getattr__`.
The fix changed `if not self._mock_unsafe:` to
`if not self._mock_unsafe and (not self._mock_methods or name not in self._mock_methods):`
so names present in the spec are exempt from the unsafe-prefix check. In v3.15.2 the
line is the same, so I restored the original condition `if not self._mock_unsafe:`.
(`or name in _ATTRIB_DENY_LIST` later additions are untouched.)

Result: a `Mock(spec=Foo)` raises AttributeError for spec'd attributes such as
`assert_bar`/`assertSome`. The oracle case `test_mock_safe_with_spec` fails with that error
(2 errors in the run in total).
