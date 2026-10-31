# Rationale

Fix hunk reversed: the first hunk of `Lib/argparse.py` in `_format_usage`. It replaced the
regex-based splitting of the usage into wrappable parts with `_get_actions_usage_parts`.

In v3.15.2 `_get_actions_usage_parts` already returns separate parts and a `pos_start` index.
The whole group-then-separate formatter that the fix removed is gone, so I put back only the
wrapping-time part. `_format_usage` now joins `parts[:pos_start]` and `parts[pos_start:]`
into strings. It re-splits them with the old `part_regexp` (`\(.*?\)+(?=\s|$)|\[.*?\]+(?=\s|$)|\S+`)
and restores the two `assert ' '.join(parts) == usage` checks.

Effect: when usage must wrap, metavars containing whitespace, newlines, or brackets and
parentheses are mis-split. The assertion fires, or the mutually exclusive group is broken
across the wrong boundary (gh-62090, 62549, 77048, 82091, 89743, 96310).

Failing oracle cases (11): `TestHelpUsageNoWhitespaceCrash` (`test_empty_metavar_required_arg`,
`test_newline_in_metavar`, `test_mutex_groups_with_mixed_optionals_positionals_wrap`), plus
`TestMutuallyExclusiveLong` and `TestMutuallyExclusiveLongParent`. In the latter two, the usage/help
tests with wrapped mutex groups now split a group `(a | b)` across lines wrongly.
