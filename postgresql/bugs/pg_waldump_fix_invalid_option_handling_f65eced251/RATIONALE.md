# Rationale

File/function: src/bin/pg_waldump/pg_waldump.c, main().

Traces to fix.patch hunks in main():
- Removed the early `argv[1]` check for --help/-?/--version/-V. This matches hunk 2, which added it.
- Restored `?` and `V` in the getopt_long optstring. This matches hunk 3.
- Restored `case '?'` (usage, exit 0) and `case 'V'` (print version, exit 0) in the option switch. This matches hunks 4 and 5.

Why this brings the bug back: getopt_long returns '?' for an unknown option, and `case '?'` treats that as a help request. An invalid option therefore prints usage to stdout and exits 0, with no error message.

Not changed: the usage() "Report bugs" line, which is already present in the current code.

Failing oracle case: src/bin/pg_waldump|t/001_basic.pl|pg_waldump with invalid option nonzero exit code (1/92 fails).
