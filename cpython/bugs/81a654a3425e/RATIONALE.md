# Rationale

Most of the fix's call sites were already `raise ArgumentError` in v3.15.2 (parse_args and
parse_intermixed_args handle `exit_on_error`). In `Lib/argparse.py` I reverted four hunks of the
fix, each back to the old `self.error(...)` call, which exits via SystemExit even when
`exit_on_error=False`:

- `_parse_known_args`, required actions: `raise ArgumentError(None, 'the following arguments are required...')` -> `self.error(...)`.
- `_parse_known_args`, required mutually exclusive group: `raise ArgumentError(...)` -> `self.error(msg % ...)`.
- `_parse_optional`/option lookup, ambiguous option: `raise ArgumentError(None, msg % args)` -> `self.error(msg % args)`.
- `_read_args_from_files`, OSError: `raise ArgumentError(None, str(err))` -> `self.error(str(err))`.

These are the same defect: the internal code calls error() directly, so it never reaches the
higher-level handler that decides between error() and raising.

Failing oracle cases (14 errors, SystemExit: 2 instead of ArgumentError) include TestExitOnError
test_required_args, test_required_mutually_exclusive_args, test_ambiguous_option, test_os_error.
