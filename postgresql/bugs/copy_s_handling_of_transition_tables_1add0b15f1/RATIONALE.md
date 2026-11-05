# Rationale
- File/function: src/backend/commands/copyfrom.c, CopyMultiInsertBufferFlush (indexed-table branch calling ExecARInsertTriggers after ExecInsertIndexTuples).
- Traces to the fix.patch hunk in CopyFromInsertBatch (copy.c): the call passed NULL instead of cstate->transition_capture. I restored the NULL.
- Effect: for tables with indexes, COPY-inserted rows are not captured into AFTER trigger transition tables.

Failing oracle case: src/test/regress||triggers
