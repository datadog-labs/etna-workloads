# Rationale

Changed: src/src/backend/executor/execExpr.c, `ExecInitJsonCoercion()`.
Traces to the fix.patch hunk that sets `exists_cast_to_int = exists_coerce && getBaseType(returning->typid) == INT4OID`.
The flag is now always false (`false && ...`), so EXISTS columns of integer (or domain over integer) type no longer use the bool_int4 cast in `ExecEvalJsonCoercion`. They fall through to jsonb_in("true"/"false") followed by json_populate_type, which calls int4in on a boolean literal and fails.

Failing oracle case: src/test/regress||sqljson_jsontable
