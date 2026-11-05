Adapted reverse of the fix: Hash node hash keys go back to being evaluated against the "inner" tuple slot rather than the outer one.

1. src/backend/executor/nodeHash.c, MultiExecPrivateHash and MultiExecParallelHash: the slot from the Hash node's child is stored in econtext->ecxt_innertuple instead of ecxt_outertuple. This traces to the two `ecxt_innertuple` -> `ecxt_outertuple` hunks in fix_impl.patch.
2. src/backend/optimizer/plan/setrefs.c, set_hash_references: the Hash's hashkeys are fixed up with INNER_VAR instead of OUTER_VAR. This traces to the setrefs.c hunk that adds set_hash_references, which makes the keys reference the Hash node's outer plan.

Why this brings the bug back: the Hash node's hashkeys no longer use the proper representation. They reference INNER_VAR on a Hash node, which has no inner plan, so the key representation is wrong.

Failing oracle case: src/test/regress||join_hash
