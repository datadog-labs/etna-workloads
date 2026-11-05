# Rationale

Hunk: src/src/backend/commands/copyfrom.c, CopyFrom().
Traces to the fix.patch hunk in CopyFrom() that added `ExecCleanUpTriggerState(estate)` before `FreeExecutorState`.
In current code, trigger target relations are closed by ExecCloseResultRelations(). The change empties
`estate->es_trig_target_relations` just before that call, so the relations opened by
ExecGetTriggerResultRel() (row triggers fired on partitions during COPY) are never closed.
That leaks relcache references ("relcache reference leak" warnings).

Failing oracle case: src/test/regress||triggers
