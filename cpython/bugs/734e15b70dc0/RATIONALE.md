# Rationale (Lib/argparse.py only)

v3.15.2 already had the fix's structure (`_set_color`), so the old behaviour was re-expressed on top of it:

- `HelpFormatter.__init__`: restored the `prefix_chars='-'` and `color=False` parameters (fix removed `prefix_chars`), stored `_prefix_chars`, and call `_set_color(color)`.
- `_is_long_option` / `_is_short_option`: restored the prefix_chars-based versions (fix hunks replacing them with `len(string) > 2`).
- `_get_actions_usage_parts` and `color_option_strings`: restored the long/short/else branches (the fix collapsed them).
- `ArgumentParser._get_formatter`: restored the `isinstance(..., HelpFormatter)` branch that passes `prefix_chars=`/`color=` to the formatter class, and the `else` branch that builds `formatter_class(prog=...)` with no color applied. The fix replaced this with `formatter_class(prog=)` + `_set_color`.

Effects: a custom subclass whose `__init__(self, prog)` raises TypeError; a function formatter ignores `color=True`.

Oracle failures: test_argparse TestHelpCustomHelpFormatter / TestColorized `test_custom_formatter_function` and `test_custom_formatter_class` (1 failure, 2 errors in check.sh).
