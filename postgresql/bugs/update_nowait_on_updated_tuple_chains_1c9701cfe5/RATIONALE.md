# Rationale

File: src/backend/access/heap/heapam_handler.c, function heapam_tuple_lock.
Traces to the fix.patch hunk in EvalPlanQualFetch (execMain.c) that made the wait for
a concurrently-updating xmax honor noWait (ConditionalXactLockTableWait + ERROR 55P03).
In current code that logic lives in the wait_policy switch inside heapam_tuple_lock's
updated-chain loop. I replaced the switch with an unconditional XactLockTableWait, so
FOR UPDATE NOWAIT (and SKIP LOCKED) block on updated tuple chains instead of erroring.

Failing oracle case: src/test/isolation||nowait-4 (nowait-5 still passes).
