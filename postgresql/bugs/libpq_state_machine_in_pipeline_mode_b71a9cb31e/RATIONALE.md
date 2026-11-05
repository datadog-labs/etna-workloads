# Reintroduced bug: libpq pipeline-mode state machine

Both hunks are in `src/interfaces/libpq/fe-exec.c`. They trace to the fix.patch hunks for the `PQsendQuery*`, `PQsendPrepare` and `PQsendDescribe` senders, and to the `PQpipelineSync` hunk.

1. `pqAppendCmdQueueEntry()`: the fix moved the `asyncStatus = PGASYNC_BUSY` change to send time. That logic now lives in this one helper, which every sender calls. I restored the pre-fix condition, so BUSY is set only when `pipelineStatus == PQ_PIPELINE_OFF`. In pipeline mode, sending a query no longer moves the connection out of IDLE.
   - fix.patch hunks: PQsendQueryInternal, PQsendPrepare, PQsendQueryGuts and PQsendDescribe.
2. `pqPipelineSyncInternal()`: after the Sync entry is queued, I call `pqPipelineProcessQueue(conn)`. This is the pre-fix behaviour, where `PQpipelineSync` applied the state change that moves the connection out of IDLE.
   - fix.patch hunk: PQpipelineSync.

## Effect
Without a Sync, `asyncStatus` stays IDLE after queries are sent in pipeline mode. A `PQgetResult` call made before `PQpipelineSync` (for example after `PQsendFlushRequest`) therefore returns an unexpected NULL.

## Oracle cases that fail
With the change, `t/001_libpq_pipeline.pl` hangs in the libpq_pipeline test client. The client loops forever printing "message type 0x.. arrived from server while idle", because the connection stays IDLE while results arrive. The oracle run was stopped at the background time limit (about 30 minutes) both times, so it never produced a per-case list. The test file as a whole fails by hanging. The cases that exercise a pipeline without an early sync (nosync, pipeline_idle and similar, with their trace-match cases) are the ones expected to fail. I did not confirm each case.
