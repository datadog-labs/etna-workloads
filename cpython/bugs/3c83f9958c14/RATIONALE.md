# Rationale

Reverses the `Lib/argparse.py` hunk of the fix (gh-72795) in `_get_positional_kwargs`.
v3.15.2 has `nargs not in [OPTIONAL, ZERO_OR_MORE, REMAINDER, SUPPRESS]` (the `nargs == 0`
ValueError is now raised separately, so it is left alone). I restored the pre-fix logic:
required unless nargs is `?` or `*`, and `*` without an explicit `default` is required again.
REMAINDER and SUPPRESS positionals become required again.

Oracle failures (test_argparse): `test_required_args_zero_or_more` and `test_required_args_remainder`
get "required: bar, baz" instead of "required: bar", and the mutually exclusive group test with
`nargs='*'` and no default (e.g. `--foo` alone) fails with a required-argument error. check.sh
reports 4 failures and 19 errors.
