# Rationale

Fix hunk reversed: `Lib/_pyrepl/readline.py` `get_completions`, which changed
`if module_completions := self.get_module_completions():` to an
`is not None` check. The `_module_completer.py` hunk (`[]` -> `None` when the
line does not parse) is already in v3.15.2 (it returns `None`), so it was not touched.

In v3.15.2 the module completer returns a `(names, action)` tuple, so a bare
truthiness test is always true for a parsed import line. I restored the old
"empty result is falsy" semantics by testing `module_completions[0]` (the names),
so an import line with no candidates falls back to regular namespace completion.

Failing oracle cases: `TestPyReplModuleCompleter.test_no_fallback_on_regular_completion`
(e.g. `from typong import Na<TAB>` completes to `NameError(` instead of staying
unchanged), plus related completer cases (6 failures in total).
