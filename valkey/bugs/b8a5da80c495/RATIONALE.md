# Rationale
Reverses the sinterGenericCommand hunks of fix.patch in src/t_set.c: removes the `empty` counter and the
deferred "empty set" block after the lookup loop, and restores the early return inside the loop that, on the
first missing key, deletes dstkey and replies (0 / empty set) before later keys are type-checked.
(The 9.0.7 `cardinality_only` reply branch is kept in the restored early return.)
Result: `SINTERSTORE dst missing wrongtype_key` deletes dst and returns 0 instead of WRONGTYPE; likewise SINTER
returns an empty set instead of WRONGTYPE.
Failing oracle cases: "SINTER against non-set should throw error", "SINTERSTORE against non-set should throw error"
(and SINTERCARD against non-set, where applicable).
