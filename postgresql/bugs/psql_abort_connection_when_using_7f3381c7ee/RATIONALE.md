# Rationale

The fix added, in `ExecQueryAndProcessResults()` (src/bin/psql/common.c), a `piped_syncs > 1` check
on COPY results that aborts the connection (fix.patch hunk in common.c). In REL_18_6 that check was
subsumed by a broader check (`PQpipelineStatus() != PQ_PIPELINE_OFF` -> "COPY in a pipeline is not
supported, aborting connection", exit(EXIT_BADCONN)) at the same place. I removed that block, so psql
no longer aborts when COPY TO/FROM runs in a pipeline (including after \syncpipeline) and instead
proceeds into COPY handling with a desynchronised pipeline.

Failing oracle cases (src/bin/psql|t/001_basic.pl):
- COPY FROM in pipeline: fails: matches
- COPY TO in pipeline: fails: exit code not 0
- COPY TO in pipeline: fails: matches
- \copy from in pipeline: fails: matches
- \copy to in pipeline: fails: exit code not 0
- \copy to in pipeline: fails: matches
