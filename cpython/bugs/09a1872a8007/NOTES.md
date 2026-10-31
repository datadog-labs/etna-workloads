repro.py parses `':Foo '` with `email._header_value_parser.get_display_name` (bpo-32178) and prints `.value` and `.display_name` of the resulting empty DisplayName.

- Clean: prints `''` twice, exit 0.
- Buggy: `.value` raises `IndexError: list index out of range` (it indexes `self[0]` on an empty token list), exit 1.
