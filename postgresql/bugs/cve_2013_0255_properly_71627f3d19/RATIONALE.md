# Rationale

## src/include/catalog/pg_proc.dat, enum_recv entry (oid 3532)

Traces to the pg_proc.h hunk in fix.patch. The fix changed enum_recv's first
argument type from cstring to internal. I reverted that:
`proargtypes => 'cstring oid'`.

With this declaration enum_recv is again a function that takes cstring, so it
can be called from SQL. It treats its first argument as a StringInfo, which is
the problem the original commit addressed. The type_sanity regression test
checks the argument types of receive functions and flags this declaration.

## Hunks not reproduced

- enum.c: the fix removed the `get_fn_expr_argtype` guard and the pg_type.h
  include. The guard is already absent from REL_18_6, so there is nothing to
  revert there.
- catversion.h: the fix bumped the catalog version. I did not change it.

## Failing oracle cases

- src/test/regress||type_sanity
