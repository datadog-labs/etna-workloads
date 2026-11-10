# Rationale

Bug: the coverage report printed each file as a flat row with its full relative path
(e.g. `test/fixtures/test-runner/coverage.js`). Long paths were truncated from the start,
leaving partial names such as `…ap/a.js`. The fix prints a directory tree with only the
file's base name on each row.

Change (lib/internal/test_runner/utils.js, `getCoverageReport`), reversing the fix's hunks:
- Column sizing: the file column width is again the longest full relative path (not the
  tree's longest part plus depth), and the narrow-terminal shrink logic is the old
  `columnsExtras * 0.2` heuristic. This matches the fix's sizing hunk.
- Removed `writeReportLine` and `printCoverageBodyTree`, and restored the old flat
  Head/Body/Foot code. The body emits the full relative path per file. The footer has no
  trailing space after `|`. This matches the fix's rendering hunk.
- `buildFileTree` is left in the file but is no longer called. The fix added it, so it is dead code now.

Failing tests with this change: parallel/test-runner-coverage and
parallel/test-runner-coverage-thresholds. Both report `not ok`, because the output is a
flat table instead of the expected tree. I ran them twice and both failed both times.
