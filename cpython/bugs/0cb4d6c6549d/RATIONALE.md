# Rationale

## Hunk changed
`tree/Lib/argparse.py`, `ArgumentParser.add_subparsers` (line ~2114):
`formatter.add_usage(None, ...)` -> `formatter.add_usage(self.usage, ...)`.

This reverses the single implementation hunk of the fix, which changed
`formatter.add_usage(self.usage, ...)` to `None`. The surrounding code has
changed (color handling, required optionals) but the call is the same, so the
default subparser `prog` is again built from the main parser's custom usage.

## Oracle failures
test_argparse: two failures (test_parse_args_failures_details_custom_usage and its
variant): with a custom main usage, subparser errors and usage show the main
parser's full custom usage as the prog prefix instead of `PROG bar 1` / `PROG bar 3`.
