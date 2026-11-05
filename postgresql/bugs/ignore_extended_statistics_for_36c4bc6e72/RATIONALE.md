# Rationale

The original fix made the planner ignore extended statistics for inheritance
trees. It did this with `rte->inh` early returns in four places. Today's code
no longer does that. It builds separate stxdinherit=true statistics and matches
them to the RTE through `info->inherit != rte->inh`. I re-expressed the bug in
the matching `selfuncs.c` hunk of fix.patch, `estimate_multivariate_ndistinct`.

Both hunks are in `src/backend/utils/adt/selfuncs.c`, function
`estimate_multivariate_ndistinct`.

1. The stats filter changed from `info->inherit != rte->inh` to `info->inherit`.
   The function now only considers non-inherited statistics, whatever the RTE is.
   This traces to the fix.patch hunk adding the `rte->inh` check in this
   function. The stats are handled without regard to the inheritance state of
   the RTE.
2. `statext_ndistinct_load(statOid, rte->inh)` became
   `statext_ndistinct_load(statOid, false)`. This loads the non-inherited
   ndistinct data even for an inheritance parent. It goes with hunk 1.

Together, the non-inherited stats (built from the parent's own rows only) are
used to estimate for an inheritance tree. This is the original bug. The stats
do not represent the child rels, so the ndistinct estimates are wrong.

Failing oracle case: `src/test/regress||stats_ext`
