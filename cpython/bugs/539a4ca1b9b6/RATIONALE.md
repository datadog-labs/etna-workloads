# Rationale

Fix hunk reversed: in `Lib/traceback.py::_compute_suggestion_error`, the fix changed
`return _suggestions._generate_suggestions(d, wrong_name)` to store the result and only
return it if truthy. I restored the early unconditional return. When the C `_suggestions`
module is available and finds no match, the function returns None right away. The
Levenshtein fallback and the nested-attribute lookup (`_check_for_nested_attribute`) are
never reached, so nested suggestions like `inner.value` disappear.

The other fix hunks add the nested-attribute helper and its call. Both are still present
in v3.15.2 and untouched. The bug lives only in the early return.

Oracle: the `test_getattr_nested_*` tests in `Lib/test/test_traceback.py` fail, e.g.
`test_getattr_nested_with_property`. They get no "Did you mean" suggestion. Other
suggestion tests that rely on the pure-Python fallback may fail as well.
