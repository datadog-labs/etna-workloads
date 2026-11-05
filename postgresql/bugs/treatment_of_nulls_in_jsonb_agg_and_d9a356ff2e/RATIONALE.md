# Rationale
File: src/backend/utils/adt/jsonb.c, functions jsonb_agg_transfn_worker and jsonb_object_agg_transfn_worker.

Traces to the fix.patch hunks that changed `datum_to_jsonb(val, false, ...)` to `datum_to_jsonb(val, PG_ARGISNULL(1), ...)` (jsonb_agg) and `PG_ARGISNULL(2)` (jsonb_object_agg value). In current code the call is `datum_to_jsonb_internal`. I changed `PG_ARGISNULL(1)` and `PG_ARGISNULL(2)` back to `false`. SQL NULL inputs are then no longer treated as null and are run through the type output function on a null datum. This gives wrong results or crashes instead of JSON null.

The other hunks (Assert, the key-null check) are already benign or unchanged in the current code, so I left them alone.

Failing oracle case: src/test/regress||jsonb
