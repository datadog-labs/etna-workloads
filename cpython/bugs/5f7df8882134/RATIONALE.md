# gh-96310 reintroduced in Lib/argparse.py

The fix added `if not exposed_actions_count: continue` so that a mutually
exclusive group whose members are all suppressed is skipped. In v3.15.2 the
code was rewritten (`_get_actions_usage_parts`) and suppressed actions are
dropped up front, so empty groups never reach the formatting loop.

Changes (in `_get_actions_usage_parts`):
- Removed the up-front `actions = [... help is not SUPPRESS]` filter. Suppressed
  actions are now skipped inside the part-building loop, as in the pre-fix code.
- Compute `exposed_actions_count` per group (the quantity the fix tested) and
  no longer skip groups where it is 0: `in_group = len(group) > 1 and exposed != 1`.
  An all-suppressed group (len > 1) is treated as a group, so
  `parts[start]` is indexed while no part was added -> IndexError (the traceback
  of the original report).

Oracle failures: test_help_subparser_all_mutually_exclusive_group_members_suppressed
and other test_argparse cases with suppressed mutex groups (25 errors) fail with
`IndexError: list index out of range` in `_get_actions_usage_parts`.
