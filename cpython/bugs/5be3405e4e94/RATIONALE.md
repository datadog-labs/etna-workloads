# Rationale

Fix (GH-75949) made `_format_usage` format optionals and positionals in one
call, so a mutually exclusive group spanning both keeps its `|` separators
when wrapping. In v3.15.2 this was already merged into a single
`_get_actions_usage_parts` returning `(parts, pos_start)`.

Change (Lib/argparse.py, `_format_usage`): instead of slicing the combined
`parts` at `pos_start`, compute `opt_parts` and `pos_parts` with two separate
`_get_actions_usage_parts` calls (optionals only, positionals only). This is
the pre-fix code (the two-call form the fix removed). A group with both option
and positional members is then split in two, so the `|` between them is lost
and the group brackets close early.

Failing oracle case: `test_mutex_groups_with_mixed_optionals_positionals_wrap`
(the usage differs from the expected text). All other argparse tests pass.
