# Rationale

Single file changed: `tree/Lib/unittest/mock.py`.

- Removed `_set_async_signature` (fix hunk adding it) and, in `create_autospec`,
  restored the pre-fix code (fix hunk 2): always `mock = _set_signature(mock, spec)`,
  then `_setup_async_mock(mock)` if the spec is an async function. The result is a
  plain sync `def` wrapper carrying the `_is_coroutine` marker, so
  `asyncio.iscoroutinefunction` is true but `inspect.iscoroutinefunction` is false,
  and calling it does the signature check eagerly instead of on await.

Oracle failures: AsyncAutospecTest.test_create_autospec and test_patch_with_autospec
(`inspect.iscoroutinefunction` false), and test_autospec_checks_signature
(TypeError raised on call rather than when awaited).
