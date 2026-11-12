# Rationale

Hunk: src/storage/checkpoint_manager.cpp, `SingleFileCheckpointWriter::WriteTable`.
Traces to the fix's WriteTable hunk (bind indexes via a dedicated read-only bind connection instead of the caller's context).
In today's code that dedicated transaction is `checkpoint_context`; I reverted to the pre-fix behaviour of calling
`info->BindIndexes(*context)` with the caller's own context (which has an active, possibly writing transaction).
Binding then can start a transaction/take start_transaction_lock while the checkpoint lock is held, so a concurrent
FORCE CHECKPOINT deadlocks.

Results: see etna-check output below (appended).

```
FAIL     test/sql/parallelism/interquery/concurrent_force_checkpoint_unbound_index.test_slow
         ...:53  Query unexpectedly failed! FORCE CHECKPOINT;
         INTERRUPT Error: Query exceeded maximum execution time
1 of 1 oracle units fail
```
