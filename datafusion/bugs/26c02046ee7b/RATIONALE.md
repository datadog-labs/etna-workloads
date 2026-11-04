# Re-introducing #24352 (TopK re-reads an already-delivered row group)

## Changes

1. `datafusion/datasource-parquet/src/push_decoder.rs`, `PushDecoderStreamState::transition`:
   removed the `sync_rg_plan_to_decoder_frontier()` call before the runtime prune/rebuild.
   This reverses the fix's only implementation call-site hunk. `rg_plan` again trails the
   decoder by one whenever arrow-rs silently finishes a row group whose post-predicate
   selection is empty, so a later prune rebuilds the decoder from a stale plan
   (`with_row_groups(new_indices)`) and re-reads a delivered row group. The helper
   functions are left in place (the fix's unit tests still use `advance_rg_plan_to`).

2. `datafusion/datasource-parquet/src/opener/mod.rs`: removed the `has_row_selection`
   guard on building the `RowGroupPruner` (added later by #24355). This is a *different*,
   later fix, but it also masks the #24352 scenario: in the oracle query
   `search_phrase <> ''` yields a page-index row selection, so in 55.2.0 the pruner is never
   built and change 1 alone has no effect (verified: oracle passes with change 1 only).
   When the fix landed the guard did not exist, so this restores the pre-fix state.
   Side effect: the #24355 regression cases in the same slt (`rgsel`) also fail.

## Oracle failures

`dynamic_row_group_pruning.slt`: the `q26` query
(`SELECT search_phrase FROM q26 WHERE search_phrase <> '' ORDER BY event_time LIMIT 10`)
returns wrong rows (rows duplicated from a re-read row group displacing the true top-k tail).
The two `rgsel` queries also fail, due to change 2 (the #24355 bug).
