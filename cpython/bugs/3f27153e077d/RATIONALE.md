# Rationale

Bug: gh-58573. The ambiguous-option check ran while parsing (in `_parse_optional`),
so an abbreviation ambiguous in the parent parser raised even when the option was
meant for a subparser. The fix moved the check to `consume_optional`.

Changes (all in `Lib/argparse.py`):
- `consume_optional`: removed the `len(option_tuples) > 1` ambiguity check (reverses the fix hunk adding it).
- `_parse_optional`: restored the ambiguity check right after `_get_option_tuples` (reverses the hunk removing it). The list return shape is kept, as the rest of the current code relies on it.

The `_get_nargs_pattern` hunks are a separate change and were not touched.

Failing oracle case: `TestAddSubparsers.test_abbreviation`: `parser.parse_args(['bar', '--fo', 'baz'])`
now errors with "ambiguous option: --fo could match --foodle, --foonly" instead of passing `--fo` to the subparser.
