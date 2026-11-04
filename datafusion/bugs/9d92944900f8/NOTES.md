Reproducer for the `Statistics::with_fetch` Inexact->Exact(0) promotion bug.
repro.sql writes two small parquet files (Exact stats), and runs the subquery.slt
regression query: count(*) over a grouped query with a scalar subquery and NOT EXISTS.
Clean build returns `2`; buggy build returns `0` because AggregateStatistics folds the count to a literal.
