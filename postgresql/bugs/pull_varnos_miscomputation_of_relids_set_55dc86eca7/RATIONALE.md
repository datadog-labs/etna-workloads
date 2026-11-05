# Rationale

Changed hunk: `src/backend/optimizer/util/var.c`, `pull_varnos_walker()`, PlaceHolderVar branch.
Traces to the var.c hunk of fix_impl.patch (the `IsA(node, PlaceHolderVar)` hunk).

The fix made a PHV contribute its `ph_eval_at` from the PlaceHolderInfo. I restored the old code
instead. It walks the PHV's `phexpr` with a sub-context, intersects the result with `phv->phrels`,
and falls back to `phrels` if that is empty. It never consults `ph_eval_at`. A PHV whose
evaluation level was pushed up (for example by outer-join delay) therefore gets a wrong, smaller
relid set. It also ignores `phnullingrels`.

Failing oracle case: src/test/regress||join
