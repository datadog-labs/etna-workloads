Reproducer (`repro.sql`) is the SQL form of misc4-7.1. It turns defensive mode off, corrupts the schema through `writable_schema` so the `sql` text has an unterminated `[M%s%s...` token, then runs VACUUM.

Clean shell: `Error near line 5: unrecognized token: "[M%s%s..."`, exit 1.
Buggy shell: segfault (exit 139). The error message is used as a printf format string, so the `%s` conversions read garbage arguments.
(misc4-7.2 was not separately reproduced.)
