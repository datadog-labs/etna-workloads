# Rationale

Hunk: `src/pl/plpython/plpy_procedure.c`, `PLy_procedure_get()`.

Traces to the fix.patch hunk in `PLy_procedure_get` that builds the cache key
`{fn_oid, fn_rel}`, so a trigger function gets a separate cached PLyProcedure
per triggered-on relation. The code now sets `key.fn_rel = InvalidOid` instead
of `fn_rel`. A trigger function used on several tables therefore shares one
cache entry, which holds the first table's row type info. Calling it on
another table uses the wrong tuple descriptor, which is the original bug.

Failing oracle case: `src/pl/plpython||plpython_trigger`
