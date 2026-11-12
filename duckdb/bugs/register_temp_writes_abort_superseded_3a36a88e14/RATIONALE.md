# Rationale

## Hunk changed
`src/src/main/query_result.cpp`, `QueryResult::ExecuteTask()`.
Traces to the fix's hunk in `src/main/query_result.cpp` (`ExecuteTask`). The fix ends a FINISHED step unless the buffer is DRAINING, so a zero-row statement that finishes undecided is ended too. In today's code the condition is `(!buffer || Lifetime() != DRAINING)`. I restored the pre-fix condition `buffer && buffer->Lifetime() == ResultLifetime::RETAINED`. A zero-row streaming statement that finishes while its lifetime is still undecided is then never ended by the step that reports FINISHED. The query stays open and the transaction stays held, so a later statement is refused or the transaction is aborted.

The other hunks of the fix (temp-write registration, `AbortInternal`, `InitialCleanup`, `TryFetchUnit`, the assert) already look different in v2.0.0. The `writes_temporary`/`MayWrite` code is gone. I left them alone and changed only this hunk.

## Oracle results
3 of 170 units fail (full output in `notes/etna_check_output.txt`):
- `test_capi_pending.cpp::Test a zero-row streaming pending query stepped to ready has completed` (`SELECT 42` fails)
- `test_query_result.cpp::Stepping a zero-row stream to FINISHED ends it` (`!handle->IsOpen()` false, `SELECT 42` fails)
- `test_query_result.cpp::A DDL submission finishes without a consumer call`

The other listed units pass. This includes the three `.test` files and the rest of the C API v2 tests, which I expected to fail and did not. I did not find a further faithful hunk that would break them.
