# Rationale

Changed: `src/backend/utils/adt/datetime.c`, `ParseISO8601Number()`.

Traces to the fix.patch hunk in `ParseISO8601Number` that added special handling so a '.' with no digits after it is accepted when digits came before it (`P1.Y...`), because some strtod implementations insist on digits after '.'.
Today's code parses the whole number with one strtod call, so the old hunk can't be reversed literally. I re-expressed the bug by rejecting a number whose parsed text ends in '.' (after at least one digit). That behaves like a strtod that insists on digits after '.', and `P1.Y0M3DT4H5M6S` fails with a bad-format error again.

The other hunks (ParseFraction special case for ".", DecodeNumberField, formatting.c) are not reproduced. Removing the "." special case in ParseFraction did not make any oracle case fail on glibc, and formatting.c was already different.

Failing oracle cases: src/test/regress||interval
