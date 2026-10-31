# Rationale

In v3.15.2 `Lib/fractions.py` still has the `handle_complex` parameter of `_operator_fallbacks`, and the `forward`/`reverse` guards. The bug is restored at the call sites. The fix passed `False` for `//`, `divmod` and `%`.

- `__floordiv__/__rfloordiv__`, `__divmod__/__rdivmod__`, `__mod__/__rmod__`: dropped the third argument `False`, reversing the three call-site hunks of the fix. `handle_complex` goes back to its default `True`, so Fraction with complex falls through to `operator.floordiv(complex(a), b)`, `divmod` and `operator.mod`.

The result is a confusing traceback. The error comes from complex's own implementation and names `complex`/`complex`, not `Fraction`.

Failing oracle case: `test.test_fractions.FractionTest.test_complex_handling`. The TypeError message has the wrong operand types, so assertRaisesMessage fails.
