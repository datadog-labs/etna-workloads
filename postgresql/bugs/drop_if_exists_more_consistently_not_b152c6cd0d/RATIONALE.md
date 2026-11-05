# Rationale

Changed hunk: `src/src/backend/catalog/namespace.c`, `FuncnameGetCandidates()`.

Traces to the fix.patch hunk `@@ -928,7 +933,9 @@ FuncnameGetCandidates`. The fix changed
`LookupExplicitNamespace(schemaname, false)` to `LookupExplicitNamespace(schemaname, missing_ok)`,
followed by an early `return NULL` if the namespace is invalid. The `missing_ok` parameter
already exists in today's code, so I re-expressed the reverse by passing `false` again.

Effect: `DROP FUNCTION IF EXISTS nonexistent_schema.f()` (and similar IF EXISTS drops for
aggregates and operators that resolve through this function) raises "schema does not exist"
instead of emitting a notice and skipping.

Only this one hunk was reversed. The rest of the fix is not reverted.

Failing oracle case: `src/test/regress||drop_if_exists`.
`event_trigger` still passes.
