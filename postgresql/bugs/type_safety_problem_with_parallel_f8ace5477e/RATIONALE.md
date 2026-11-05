# Rationale

Changed: `src/backend/catalog/pg_aggregate.c`, `AggregateCreate()`, the deserialization-function validation block.

Traces to the fix.patch hunk in the same function that changed the deserialfn check from
`fnArgs[0]=aggSerialType; lookup_agg_function(..., 1, ...)` to
`fnArgs[0]=BYTEAOID; fnArgs[1]=INTERNALOID /* dummy argument for type safety */; lookup_agg_function(..., 2, ...)`.
The reverse is applied: the dummy `internal` argument is dropped and the lookup is again for a one-argument
`deserialize(bytea)` function. That is the signature that lets a user call a deserializer from SQL with arbitrary
bytea and get back an `internal` value, which is the type-safety hole. A two-argument `(bytea, internal)`
deserializer is now rejected by CREATE AGGREGATE.

This is a partial reversal. The fix also removed the SERIALTYPE parameter, which the current code does not have.

Failing oracle case: `src/test/regress||create_aggregate`. `opr_sanity` still passes.
