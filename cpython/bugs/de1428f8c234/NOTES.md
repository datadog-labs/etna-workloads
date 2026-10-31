repro.py builds a parser with a required option whose metavar is empty plus one with a long metavar, so usage must wrap, then prints `format_usage()`.

Clean: prints the wrapped usage. Buggy: the re-split of usage parts with the injected regexp doesn't round-trip on the empty metavar, so `assert ' '.join(opt_parts) == opt_usage` in `_format_usage` raises AssertionError.

Note: `./check.sh` failed in my sandbox (bwrap missing .claude/launch.json), so I compared the two interpreters by running them directly.
