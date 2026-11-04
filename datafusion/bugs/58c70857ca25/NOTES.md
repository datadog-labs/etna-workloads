Reproducer: runs `approx_percentile_cont_with_weight('NaN'::DOUBLE, 0, 0)` over a one-row table (the statement from the upstream aggregate.slt test).
Clean build: returns a result (NULL here), exit 0.
Buggy build: panics at tdigest.rs:613 (`assert!(max.total_cmp(&min).is_ge())` when the state has non-finite min/max), exit 101.
