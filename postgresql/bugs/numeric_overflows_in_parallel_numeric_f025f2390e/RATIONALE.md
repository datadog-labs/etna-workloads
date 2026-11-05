# Rationale

File: src/backend/utils/adt/numeric.c, functions `numericvar_serialize` / `numericvar_deserialize`
(the helpers added by the fix's "numericvar_serialize/deserialize" hunk, which replaced the
numeric_send/numeric_recv calls in the numeric*_serialize/deserialize functions).

The helpers are re-expressed with the pre-fix logic: the NumericVar is converted with make_result()
and numeric_send() (and read back with numeric_recv()). Those use 16-bit weight/dscale fields and
make_result range-checks, so intermediate sums in parallel numeric aggregates that exceed the numeric
type's limits raise overflow errors again. All callers (avg/sum/poly/int8_avg serialize/deserialize) go
through these helpers, so this reverts the fix's behavior without rewriting each caller.

Failing oracle case: src/test/regress||numeric
