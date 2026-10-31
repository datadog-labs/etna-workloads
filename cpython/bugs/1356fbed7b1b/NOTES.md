Feeds PstatsCollector one sample whose stack has the same frame 5 times (recursion).
Clean: cumulative_calls=1 (counted once per sample), prints `1 1`.
Buggy: the per-sample dedup is removed, so cumulative_calls=5, prints `5 1`.
