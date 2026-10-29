Reproducer (`repro.sql`): calls the shell's built-in `regexpi()` (case-insensitive regexp) on `('abc','ABC')` and `('ABC','ABC')`.

Clean shell prints `1` and `1`. Buggy shell prints `0` and `0`, because `regexpi` ignores case when the bug is present (regexp1-1.1.2 and 1.1.3).
