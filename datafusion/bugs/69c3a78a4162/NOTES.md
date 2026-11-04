repro.sql copies the two regression cases added to projection_pushdown.slt (struct-field join keys, issue 22895), with target_partitions=4.

Clean build: both queries return rows (1/svc1, then two timestamps).
Buggy build: both fail with "Optimizer rule 'optimize_projections' failed ... No field named a.id / r.start_timestamp", because the in-place rewrite doesn't recompute the parent schema after a child's schema changes.
