# Rationale

## src/bin/scripts/createdb.c, main()
Traces to the fix.patch hunk that replaced `ENCODING '%s'`, `LC_COLLATE '%s'` and `LC_CTYPE '%s'`
with `appendStringLiteralConn()` calls. I put the old unquoted-in-C formatting back: the values for
--encoding, --lc-collate and --lc-ctype are interpolated into single quotes with no escaping.
A value containing a quote, or a backslash under non-standard settings, produces broken or
injectable SQL. I did not reintroduce the connection-ordering hunk, since the bug is the quoting.

## Failing oracle cases
2 of 60 fail (src/bin/scripts|t/020_createdb.pl):
- createdb with incorrect --lc-collate stderr
- createdb with incorrect --lc-ctype stderr

The test passes `foo'; SELECT '1`. Unescaped, the quote ends the literal and the server reports
"CREATE DATABASE cannot run inside a transaction block" instead of an invalid-locale error.
