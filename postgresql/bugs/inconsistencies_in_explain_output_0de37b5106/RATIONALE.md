# Rationale

Changed hunk: src/backend/commands/explain.c, `show_memory_counters()`.
Traces to the last hunk of fix.patch (show_memory_counters). The fix reports memory in
kB (rounded up with BYTES_TO_KILOBYTES). I restored the old behaviour: raw bytes,
"Memory: used=N bytes  allocated=N bytes" in text format, and "bytes" units for the
Memory Used and Memory Allocated properties in the other formats. EXPLAIN (MEMORY) output
becomes inconsistent with the kB units used by the other EXPLAIN memory figures.

Other hunks were not reverted: the BYTES_TO_KILOBYTES macro still exists and its other
callers are untouched.

Failing oracle case: src/test/regress||explain
