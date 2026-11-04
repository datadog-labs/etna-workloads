repro.sql runs EXPLAIN ANALYZE (analyze_level=dev, categories=bytes) on a HashJoin and a CrossJoin over inline VALUES.
Clean build shows memory metrics as peak-memory bytes (`build_mem_used=44.0 B`, `128.0 B`).
Buggy build registers them as plain gauges, so they print as raw numbers (`build_mem_used=44`, `128`).
