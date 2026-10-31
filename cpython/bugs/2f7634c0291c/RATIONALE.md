# Rationale

Fix hunk reversed: in `ArgumentParser.__init__` the `identity` type was moved from a
local closure to the module-level `_identity`, so the parser is picklable.

In v3.15.2 `Lib/argparse.py` the formatter's `_decolor` lambda was already removed
(replaced by `_identity` / `_colorless_theme`), so that hunk can't be reverted. I reverted
only the `__init__` hunk: `self.register('type', None, _identity)` is back to a local
`def identity(string)` plus `self.register('type', None, identity)`. The local function is
stored in `parser._registries`, so pickling the parser raises
`AttributeError: Can't get local object 'ArgumentParser.__init__.<locals>.identity'`.

Oracle: `TestArgumentParserPickleable.test_pickle_roundtrip` fails for each pickle protocol
(check.sh reported 6 errors in test_argparse).
