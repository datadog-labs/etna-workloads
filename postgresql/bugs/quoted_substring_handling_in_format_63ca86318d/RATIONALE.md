# Rationale

File: src/backend/utils/adt/formatting.c, function parse_format (double-quoted literal branch).
Traces to the fix.patch hunk replacing the `x`-tracking quoted-string loop with "backslash quotes the next character".
Restored the old state variable `x` (previous char): a `"` right after a backslash-escaped backslash (`\\`) is not treated as the closing quote, and a backslash only escapes if the previous char wasn't a backslash. So `"\\"` is mis-parsed and the quoted string runs on.

Failing oracle case: src/test/regress||numeric (expected to fail; see oracle output).
