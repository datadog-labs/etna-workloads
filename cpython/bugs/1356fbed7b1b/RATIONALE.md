# gh-142374 reintroduced: recursive functions over-counted in cumulative stats

In v3.15.2 the per-sample dedup of recursive frames exists in three collectors. All three are removed, so a function that appears N times in one stack gets N cumulative counts per sample.

- `Lib/profiling/sampling/heatmap_collector.py`: reverses the fix hunks that add `_seen_lines`, the `count_cumulative` computation in `process_frames`, and the `count_cumulative` parameter of `_record_line_sample`. `line_samples` and `file_samples` are incremented unconditionally again. The now-unused `_seen_lines` set and its `clear()` remain; they are harmless.
- `Lib/profiling/sampling/live_collector/collector.py`: reverses the `_seen_locations` hunk in `process_frames`. `cumulative_calls` is incremented for every frame again.
- `Lib/profiling/sampling/pstats_collector.py`: this is the same defect in the pstats path. It was fixed in the same commit and has since been refactored to use `weight`. The `_seen_locations` guard is dropped.

The other parts of the fix (`successful_samples`, `sample_pct`, widgets) are separate improvements, not part of this bug, and are unchanged.

## Oracle failures
Running `check.sh`:
- `test_live_collector_core`: 3 cases fail, `test_process_recursive_frames_counted_once`, `test_process_mixed_recursive_nonrecursive` and `test_process_recursive_frames_multiple_samples` (for example `5 != 2`).
- `test_integration`: 1 failure.
- The collectors tests also exercise the pstats and heatmap paths.
