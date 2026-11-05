# Rationale

## src/include/nodes/pathnodes.h, macro IS_PARTITIONED_REL
Traces to the relation.h hunk of fix.patch (the last hunk, which extends IS_PARTITIONED_REL).
The fix added `(rel)->part_rels && !IS_DUMMY_REL(rel)` to the macro. I removed both conditions
and restored the older comment. Code has evolved (the other hunks' dummy checks and eager part_rels
allocation no longer exist in that form; partition bounds and part_rels are now set up in
compute_partition_bounds), so the macro is the one place the fix survives.
Without those conditions, dummy joinrels, or ones without a part_rels array, count as partitioned.
Callers such as generate_partition_wise_join_paths and try_partition_wise_join then go on to
use child-joins that were never created, which is the original crash.

## Failing oracle cases
- src/test/regress||partition_join
