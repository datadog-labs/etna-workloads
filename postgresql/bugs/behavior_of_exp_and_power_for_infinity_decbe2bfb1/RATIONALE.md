# Rationale

## src/backend/utils/adt/float.c, dexp()
Traces to the dexp() hunk of fix.patch. The explicit NaN/Inf handling and the
errno==ERANGE overflow/underflow handling are replaced with the pre-fix code.
exp(-Inf) returns 0, and the old unconditional `result == 0.0` check then raises
"underflow" for it, which is the bug. exp(+Inf) and exp(NaN) also depend on the
platform's exp().

The dpow() hunk was not reproduced. dpow() has since been restructured so that
infinite inputs are handled in their own branches, and the `!isinf` conditions
no longer matter there.

## Failing oracle cases
src/test/regress||float8 (expected; see the oracle run)
