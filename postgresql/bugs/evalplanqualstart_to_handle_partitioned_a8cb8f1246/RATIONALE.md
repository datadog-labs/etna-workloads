# Rationale

File: src/backend/executor/execMain.c, function EvalPlanQualStart.

Traces to the fix.patch hunk in EvalPlanQualStart, which made the EPQ child EState inherit
partitioned-result-relation state (es_root_result_relations) from the parent. The original
arrays no longer exist: ResultRelInfos are now built from scratch, and the root partitioned
rel is handled via es_unpruned_relids. The analogue in current code is the line
`rcestate->es_unpruned_relids = parentestate->es_unpruned_relids;`, which I removed. Without it
the EPQ child EState has no unpruned-relids set, so EPQ rechecks on a partitioned
result table (the partitioned root and its partitions) are not initialised correctly and fail.

Failing oracle case: src/test/isolation||eval-plan-qual
