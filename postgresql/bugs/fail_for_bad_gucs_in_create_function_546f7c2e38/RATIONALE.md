# Rationale

File: src/backend/catalog/pg_proc.c, function ProcedureCreate.
Traces to the sole hunk of fix_impl.patch. The `if (check_function_bodies)` guard around applying
proconfig (SET clauses) via ProcessGUCArray before calling the language validator is replaced by
`if (true)`. So the function's SET clauses are applied during validation even when
check_function_bodies is off, and a bad or not-yet-valid GUC value (e.g. a missing text search
config) makes CREATE FUNCTION fail again.

Failing oracle case: src/test/regress||guc
