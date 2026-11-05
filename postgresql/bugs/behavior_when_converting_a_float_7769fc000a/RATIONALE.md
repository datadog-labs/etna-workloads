# Rationale
File: src/backend/utils/adt/numeric.c, functions float8_numeric() and float4_numeric().
Traces to both fix.patch hunks, which added an isinf() check ahead of the sprintf into buf.
In today's code that check returns numeric +/-Infinity (the error was later replaced by infinity support).
I removed the isinf() blocks, so infinity is formatted as "inf" by snprintf and passed to the numeric string parser.
That reintroduces the bug: float infinity is not handled in the conversion.

Failing oracle case: src/test/regress||numeric
