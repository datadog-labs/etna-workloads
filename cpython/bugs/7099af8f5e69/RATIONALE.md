# Rationale

Changed `ArgumentParser.print_usage` and `print_help` in `tree/Lib/argparse.py`.
They once again call `self.format_usage()` / `self.format_help()` with no
formatter, instead of building a formatter via `self._get_formatter(file=file)`
and passing it in. This reverses the `print_usage`/`print_help` hunks of the fix.

`format_*` then create their own formatter with `_get_formatter()`, so
`_set_color(..., file=None)` is used and `can_colorize` is asked about the default
stream (stdout) rather than the file being written to. Output going to stderr or
a StringIO is colorized, or not, based on the wrong stream.

The `format_*(formatter=None)`, `_get_formatter(file=None)` and `_set_color(file=)`
plumbing is left in place. It is harmless unused, and v3.15.2 has moved it into
a lazy `_get_theme_and_decolor`.

## Failing oracle cases
- `TestColorized.test_print_help_uses_target_file_for_color_decision`
- `TestColorized.test_print_usage_uses_target_file_for_color_decision`

Both fail with `AssertionError: None is not <StringIO>`: `can_colorize` is called
with `file=None` instead of the target file.
