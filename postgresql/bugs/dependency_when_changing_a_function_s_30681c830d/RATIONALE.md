# Rationale

`SetFunctionReturnType` and `SetFunctionArgType` no longer exist in REL_18_6. Opaque was removed, and
the shell-type mechanism replaced it. The current test (`create_type`, "Check dependencies are
established when creating a new type") uses a shell type, `base_type`, instead of `opaque`.
The bug is re-expressed in the place where a function's dependencies on its argument and return types
are now recorded.

## Hunk: src/backend/catalog/pg_proc.c, `ProcedureCreate`
- Traces to both fix_impl.patch hunks, which add `recordDependencyOn(func, type, DEPENDENCY_NORMAL)`
  for the new return type and the new argument type.
- The change records the function -> return-type and function -> argument-type dependencies only
  when `get_typisdefined()` is true. A function that references a shell type therefore gets no
  dependency on it. When `CREATE TYPE` later fills in the shell, the function still has no
  dependency on the type, which is the missing-dependency bug the fix removed.
- Effect: `DROP FUNCTION base_fn_in(cstring)` and `DROP TYPE base_type` no longer report the
  dependent objects, so their output differs from the expected output.

## Failing oracle cases
- src/test/regress||create_type
