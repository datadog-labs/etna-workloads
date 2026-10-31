# RATIONALE

Fix hunk (Lib/argparse.py): `BooleanOptionalAction.__init__` raised ValueError for `--no-*` option names.
In v3.15.2 the code was restructured: the two-dash branch has
`if option_string.startswith('no-', 2): raise ValueError(...)`.
I removed that check (the equivalent of the fix's added lines), so `--no-foo` is again
accepted and silently gets a bogus `--no-no-foo` negative form.
The single-dash `-no...` check is a later addition and was left untouched.

Oracle: test_argparse invalid-name tests (the two-dash `--no-foo` case) fail because no ValueError is raised.
