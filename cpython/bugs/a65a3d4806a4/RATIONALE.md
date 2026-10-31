# Rationale

In v3.15.2 the code from the fix lives in `Lib/_py_warnings.py` (not `Lib/warnings.py`).
I changed `filterwarnings()` and `simplefilter()` there. This reverses both
`Lib/warnings.py` hunks of the fix. Each function's explicit `raise ValueError/TypeError`
validation is replaced by the original `assert` statements. The "all" action
that was added later is kept in the allowed set.

Effect: with `python -O` the validation vanishes. Otherwise invalid arguments raise
`AssertionError` instead of `ValueError`/`TypeError`.

Failing oracle cases: `PyFilterTests.test_argument_validation` and
`CFilterTests.test_argument_validation`. The first call, `filterwarnings(action='foo')`,
raises `AssertionError` where the test expects `ValueError`.
