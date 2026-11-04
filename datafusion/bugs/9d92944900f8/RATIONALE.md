# Rationale

Both changes are in `datafusion/common/src/stats.rs`, `Statistics::with_fetch`.

1. **Hunk reversed: the `nr <= skip` branch of the fix.** I restored `Precision::Exact(0)`
   and the old "upper bound" comment in place of
   `check_num_rows(Some(0), self.num_rows.is_exact().unwrap())`. This is the pre-fix code,
   so an `Inexact` input is promoted to an exact zero again.
   Reverting this alone did not make the oracle fail.

2. **Second path: the early return `if fetch.is_none() && skip == 0 { return Ok(self); }`.**
   It is not part of the fix. It was added after the fix's base and short-circuits the
   `SortExec` case from the commit message. `SortExec` calls `with_fetch(None, 0, 1)`. With
   the early return, `Inexact(0)` was returned unchanged and never reached the `nr <= skip`
   branch. Removing it lets `nr (0) <= skip (0)` reach the restored
   `Exact(0)`, which is the same promotion defect. The pre-fix code had no such early return.
   The side effect is that column stats are downgraded to Inexact for no-op fetches.

## Oracle failure
`subquery.slt`: the `select count(*) from (... group by cntrycode)` query returns `0`
instead of `2`. This is the symptom in the fix. The `Inexact(0)` is promoted to `Exact(0)` at
the `SortExec`, and `AggregateStatistics` (`Count::value_from_stats`) folds the count to a literal.
