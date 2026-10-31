# Rationale

Only change: `tree/Lib/argparse.py`, `consume_optional`, single-dash branch (`arg_count == 0 and option_string[1] not in chars and explicit_arg != ''`).

Reverses the fix hunk at `@@ -2060,18 +2060,27 @@` of gh-60346:
- removes the `if sep or explicit_arg[0] in chars: raise ignored explicit argument` check;
- restores `new_explicit_arg = explicit_arg[1:] or None` / `explicit_arg = new_explicit_arg` (dropping the `sep`/`=` re-derivation);
- restores raising `ignored explicit argument` when the next char is not a known option, instead of appending `char + explicit_arg` to `extras` and stopping.

The `sep` tuple element plumbing elsewhere is left in place (it is harmless once unused here).

## Oracle failure
`TestAddSubparsers.test_parse_known_args_with_single_dash_option` fails: `parse_known_args(['-ku'])` with `-k` a count option now errors with
`argument -k/--known: ignored explicit argument 'u'` rather than returning `(NS(known=1,new=0), ['-u'])`.
