# Rationale

Fix hunks reversed (all in `sqlite3WhereEnd`, src/where.c): the fix moved
`sqlite3VdbeResolveLabel(v, pLevel->addrCont)` from before the skip-ahead-distinct
OP_Seek code to after it (just before the loop-advance opcode), so "continue"
jumps (rows rejected by WHERE terms) bypass the seek. Only the fix's label-placement
hunks are reverted. The `pE->iTable==iIdxCur` and SQLITE_DEBUG hunks are not,
because that code has since been rewritten.

In 3.54.1 the label is resolved just before the advance opcode. I reintroduced the
old placement: when the skip-ahead block is generated, `addrCont` is resolved at
its start (before the OP_Column/OP_Seek code), with a local flag
`bContResolved` so it isn't resolved a second time later. When the block is not
generated, behaviour is unchanged. The label is resolved before the EXISTS-break
Goto only for the seek case, which preserves the old code ordering.

Effect: a row that fails the WHERE clause jumps to the seek, which skips every row
sharing the DISTINCT prefix, even though other rows of that prefix might match.

Failing oracle case: distinct2-830
(`CREATE INDEX i8 ON t8(a,c); ANALYZE; SELECT DISTINCT a,b,c FROM t8 WHERE b=3;`
returns the wrong result instead of `1 3 1`).
