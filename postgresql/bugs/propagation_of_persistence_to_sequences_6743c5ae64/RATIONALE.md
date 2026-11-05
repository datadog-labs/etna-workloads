Changed: src/backend/parser/parse_utilcmd.c, generateSerialExtraStmts() (persistence determination, `seqpersistence`).

Traces to the fix.patch hunk in the same function that set the sequence's relpersistence from `cxt->rel ? cxt->rel->rd_rel->relpersistence : cxt->relation->relpersistence`. The change reverts this to `cxt->relation->relpersistence` only. In ALTER TABLE ... ADD COLUMN the parser doesn't set relation->relpersistence, so sequences for serial/identity columns added to an unlogged or temp table come out permanent instead of inheriting the table's persistence.

Failing oracle case: src/test/regress||identity
