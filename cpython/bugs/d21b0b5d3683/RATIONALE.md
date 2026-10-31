# Rationale

Fix (gh-113008): the usage builder compared group members to the parser's action list
by order (`actions[start:end] == group._group_actions`), so a required mutually exclusive
group mixing an optional and a positional was formatted wrongly when the group was declared
in a different order than the usage layout (optionals first, positionals after). The fix made
the comparison order-insensitive (`min(index)` / `set(...)`).

In v3.15.2 this logic was rewritten (`_get_actions_usage_parts`). The equivalent today is the
positional branch, which puts the group's options first and then the positional. I changed it
(Lib/argparse.py) to build the group's parts in `group._group_actions` order (the positional
is kept at its declared place), i.e. dependence on declaration order again.

Oracle failures: `test_optional_order` (both Parent variants) — with `bar` declared before
`--foo` usage reads `(bar | --foo FOO)` instead of `(--foo FOO | bar)`; also the
`TestMutuallyExclusiveOptionalsAndPositionalsMixed*` usage/help tests, which depend on the same ordering.
