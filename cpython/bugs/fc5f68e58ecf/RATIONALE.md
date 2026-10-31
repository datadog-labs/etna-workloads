# Rationale

The fix's `Lib/unittest/loader.py` hunks still apply to v3.15.2, so I reversed them directly in `TestLoader.discover`:

- Removed `original_top_level_dir = self._top_level_dir` at the start of `discover()`.
- Removed `self._top_level_dir = original_top_level_dir` before `return self.suiteClass(tests)`.

`discover()` once again leaves `_top_level_dir` set after the call. This is the pre-fix behaviour.

The doc, test and NEWS hunks are not implementation files, so I left them alone.

## Oracle failures
- `test_discover_should_not_persist_top_level_dir_between_calls`: fails with `'/foo' != None`.
- `test_discover`: fails because `loader._top_level_dir` is `/foo/bar` where the updated test expects `/foo`.
