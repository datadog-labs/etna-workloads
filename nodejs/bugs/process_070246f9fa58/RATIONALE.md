# Re-introduced bug: process.versions / report componentVersions not sorted

Before the fix, versions were emitted in the order of the NODE_VERSIONS_KEYS macro (v8, uv, zlib, ...) rather than alphabetically (with `node` first). The fix sorted them in `process.versions` and in the diagnostic report's `componentVersions`.

## Change
Single hunk in `src/node_metadata.cc`, `Metadata::Versions::pairs()`: removed the `std::ranges::sort(...)` call. In today's code the sorting from both fix hunks (`src/node_process_object.cc` and `src/node_report.cc`) was refactored into this shared helper, which both callers use, so removing the sort restores the unsorted order in both places.

## Failing test
`parallel/test-process-versions` fails: `AssertionError: Expected values to be strictly deep-equal` on the key order of `Object.keys(process.versions)` (actual: node, v8, uv, zlib, brotli, zstd, ares...; expected: node, acorn, ada, amaro, ares, brotli, ...).
