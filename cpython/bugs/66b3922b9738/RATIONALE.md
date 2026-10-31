# Rationale

Changes in `tree/Lib/argparse.py`:

1. `_check_value`: fix hunk changed `{'value': value, 'choices': ', '.join(map(repr, action.choices))}`
   to `str(value)` / `map(str, ...)`. v3.15.2 had `repr(str(choice))` (a later variant);
   restored the pre-fix `value` and `map(repr, action.choices)`. The invalid-choice
   message again shows `<Color.RED: 'red'>` for enum choices instead of `red`.
2. `_get_action_name`: restored `'{' + ','.join(argument.choices) + '}'` (no `str()`),
   which raises TypeError for non-string choices (e.g. ints, enums) when naming
   an action without dest/metavar.

The `_metavar_formatter`/`_expand_help` hunks were pure refactors (equivalent), not reverted.

Failing oracle cases: TestStrEnumChoices.test_invalid_enum_value_raises_error
(message lists enum reprs) plus two others (3 failures total) in test_argparse.
