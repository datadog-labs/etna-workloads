# Rationale

Changed: `src/backend/executor/nodeIndexonlyscan.c`, `ExecInitIndexOnlyScan`.
Traces to the fix.patch hunk that changed `indexstate->indexqual = ExecInitQual(node->indexqual...)` to `indexstate->recheckqual = ExecInitQual(node->recheckqual...)`.
Reverted: the lossy-index recheck qual is built from `node->indexqual` (index-column form, which may reference non-returnable index columns) instead of `node->recheckqual` (which uses only retrievable columns). The recheck in IndexOnlyNext therefore evaluates against index columns the AM can't return, giving wrong results or plans for GiST.

Failing oracle case: `src/test/regress||gist`
