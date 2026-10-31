# Rationale

## Lib/argparse.py (`_get_actions_usage_parts_with_split`, positional branch)
Reverses the single implementation hunk of the fix. The color wrapping
(`t.summary_action + ... + t.reset`) is applied again *before* the
"strip the outer []" step, so `part[0]` is the ANSI escape rather than `[`
and the brackets are never stripped for positionals in a mutually exclusive
group. (v3.15.2 uses `in_group` instead of `action in group_actions`; that
condition is unchanged.)

## Oracle failure
`TestColorized.test_argparse_color_mutually_exclusive_group_usage` fails: usage
shows `[badger ...]` inside the group instead of `badger ...`.
