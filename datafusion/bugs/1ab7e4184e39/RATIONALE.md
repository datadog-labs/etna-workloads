# Rationale

Fix (#19853) added a `requires_grouping_id` check to `ensure_distribution` so that
hash partitioning on a subset of the keys cannot satisfy a requirement that includes
`__grouping_id`. In 55.2.0 the code lives in
`datafusion/physical-optimizer/src/ensure_requirements/enforce_distribution.rs`.

Changes (all in that file):

1. Hunk "allow_subset_satisfy_partitioning ... && !requires_grouping_id" — removed
   `&& !requires_grouping_id` from `allow_subset_satisfy_partitioning`, and removed the
   `requires_grouping_id` computation (and the now-unused `Aggregate` import, plus the
   "3. Not a grouping set aggregate" comment line). This restores the pre-fix condition
   (`threshold met && !is_partitioned_join`).
2. Second path (not in the original fix; added later in 55.2.0): `preserve_satisfying_file_partitioning`
   also had `&& !requires_grouping_id`. It is the same defect (a subset-satisfying
   partitioning accepted for a grouping-id requirement), so that guard was removed too.

## Oracle failure

`grouping_set_repartition.slt` fails at the TEST 1 query (UNION ALL + ROLLUP): the
RepartitionExec on `[channel, brand, __grouping_id]` is skipped, so partial aggregates
from different partitions are finalized independently, giving duplicate grand-total rows
(`NULL NULL 2100`, `NULL NULL 2400`, ... instead of `NULL NULL 4500`).
