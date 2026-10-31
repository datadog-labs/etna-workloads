repro.py builds a required mutually exclusive group containing `--foo` and a positional `bar` (nargs='?'), in both add orders, and prints the usage.

Clean: `(--foo FOO | bar)` in both orders. Buggy: when `bar` is added first, usage shows `(bar | --foo FOO)`, so the optional-before-positional ordering is lost.
