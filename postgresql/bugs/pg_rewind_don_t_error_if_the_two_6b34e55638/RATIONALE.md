# Rationale

Changed: src/bin/pg_rewind/pg_rewind.c, main(), the `target_tli == source_tli` branch.

Traces to the fix_impl.patch hunk that replaced `pg_fatal("source and target cluster are on the same timeline")` with an info message plus `rewind_needed = false`. The change reverts that: the same-timeline case calls pg_fatal again, so pg_rewind errors out instead of reporting that no rewind is needed.

Failing oracle case:
- src/bin/pg_rewind|t/005_same_timeline.pl|pg_rewind local
