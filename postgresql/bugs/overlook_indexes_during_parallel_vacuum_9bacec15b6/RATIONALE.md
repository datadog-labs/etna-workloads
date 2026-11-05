# Rationale

File/function: src/backend/commands/vacuumparallel.c, parallel_vacuum_process_unsafe_indexes().

Traces to the fix.patch hunk in do_serial_processing_for_unsafe_indexes() (vacuumlazy.c). The fix made the leader
process indexes that have no DSM stats slot (those under the size cutoff). Before the fix, the leader skipped
those indexes as "already complete" (shared_istat != NULL was required).
In today's code the equivalent is `!will_parallel_vacuum[i]`. I added it to the skip condition, so small
indexes that workers never handle are also skipped by the leader and never vacuumed or cleaned.

Failing oracle case: src/test/regress||vacuum_parallel
