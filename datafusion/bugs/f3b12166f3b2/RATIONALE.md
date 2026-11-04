# Rationale

Only file changed: `tree/datafusion/datasource-parquet/src/page_filter.rs`
(`PagePruningAccessPlanFilter::prune_plan_with_page_index_and_metrics`).

55.2.0 already had the fix in a modified form (a `HashSet` of matched page
indexes per row group, intersected across predicates). I restored the pre-fix
accounting:

- Removed `total_pages_in_group` and `matched_pages_in_group` and the
  `retain` intersection. This reverses the fix hunks that added
  `total_pages_in_group` / `matched_pages_in_group` and the HashSet
  intersection.
- After each predicate's `prune_pages_in_one_row_group`, the code now adds
  that predicate's matched and skipped pages straight to `total_pages_select`
  and `total_pages_skip`. This is the pre-fix `total_pages_select += matched_pages;
  total_pages_skip += total_pages - matched_pages;`. The count is computed
  from the returned `Vec<bool>` instead of a tuple, so the helper's signature
  is unchanged.
- Removed the post-loop `pages_matched` accumulation, which reverses the
  fix hunk that added it.

Effect: with several single-column predicates on a row group, each page is
counted once per predicate, so `page_index_pages_pruned` is inflated.

## Failing oracle cases
- `explain_analyze.slt`: shows `page_index_pages_pruned=4 total → 4 matched`
  where the test expects 2.
- `limit_pruning.slt`: the same metric mismatch (4 instead of 2) in the
  TopK query.
