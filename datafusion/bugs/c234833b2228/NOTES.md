Reproducer: runs `approx_percentile_cont(c3, 0.95, -1000)` with a GROUP BY (copied from aggregate.slt) on a small inline table, target_partitions = 4.
The invalid max_size error is raised inside the plan and passes through `GenericError -> DataFusionError`.
- clean: `Error during planning: Tdigest max_size value ...`
- buggy: `External error: Error during planning: Tdigest max_size value ...` (the DataFusionError is wrapped in External instead of unwrapped)
