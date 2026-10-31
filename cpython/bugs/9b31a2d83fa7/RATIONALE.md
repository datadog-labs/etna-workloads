# Rationale

Both changes are in `tree/Lib/argparse.py` and revert the two fix hunks.

1. `HelpFormatter._format_action_invocation` (positional branch) reverses the
   first hunk. It goes back to `metavar, = self._metavar_formatter(action, default)(1)`,
   which unpacks exactly one value. v3.15.2 only adds the colour theme wrapper
   (`t.action ... t.reset`), and I kept that. A tuple metavar of length other
   than 1 now raises `ValueError` when help or usage is formatted.
2. `_get_action_name` reverses the second hunk. It goes back to
   `return argument.metavar`, so a tuple metavar is returned as a tuple. Error
   messages then show `argument ('BAZ1', 'BAZ2'): ...`, and the required-arguments
   message fails when it joins names.

Failing oracle cases: `TestHelpTupleMetavarPositional` (help and usage raise
`ValueError`), the `test_required_args_*_with_metavar` cases, and the
`test_conflicting_mutually_exclusive_args_*_with_metavar` cases. The last run
had 5 errors and 2 failures in `test_argparse`.
