# Rationale
Today's code was refactored (TryPrepareSink/TryBlockOnFlush), so the fix's hunks don't map 1:1. The backpressure
is expressed as: once a flush is active, a producer whose state reaches the flush threshold closes its input, leaving
a closed pending sinking_state, so further producers park instead of buffering another run.

Hunk: physical_copy_to_file.cpp, PartitionedCopy::Sink (flush trigger). Traces to the fix's "bound buffering while a
flush is active" Sink change. Now the state is only closed/flushed when no flush is active (`if (!flushing)`), so
the next run keeps accumulating in memory while the current flush runs, with no bound. This is the pre-fix behaviour.

Oracle result: etna-check reports "FAIL test/sql/copy/partitioned/partitioned_write_backpressure.test:33 Query unexpectedly failed" (the 128MB-limit COPY, no spilling allowed, runs out of memory); "1 of 1 oracle units fail".
