Changed: src/backend/utils/adt/selfuncs.c, eqjoinsel(), JOIN_SEMI/JOIN_ANTI case.
Traces to the fix_impl.patch hunk adding `selec = Min(selec, inner_rel->rows * selec_inner);`.
I removed that line, so the semijoin selectivity is no longer clamped to the inner-join estimate. Semijoin row estimates can then exceed the inner-join estimate, which changes plans.
The explanatory comment and the selec_inner computation are left in place.

Failing oracle case: src/test/regress||partition_join
