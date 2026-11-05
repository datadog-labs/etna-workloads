# Rationale
- File/function: src/backend/utils/adt/jsonfuncs.c, populate_recordset_worker().
- Traces to the last hunk of fix_impl.patch (setDesc copy). The fix sets `rsi->setDesc = CreateTupleDescCopy(cache->c.io.composite.tupdesc)`. I reverted it to pass the cached tupdesc directly.
- Why this brings the bug back: the executor frees the passed-back setDesc, which leaves the cache with a dangling tupdesc. That crashes when the function is called again in the same query.
- The is_json/jtype refactor hunks are not part of the crash, so I left them alone.

Failing oracle cases: src/test/regress||json, src/test/regress||jsonb
