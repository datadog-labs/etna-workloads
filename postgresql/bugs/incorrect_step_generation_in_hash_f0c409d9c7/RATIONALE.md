# Rationale

File: src/backend/partitioning/partprune.c

Functions: get_steps_using_prefix, get_steps_using_prefix_recurse, and the three call sites in gen_prune_steps_from_opexps (the 0, pc->keyno, pc->keyno arguments).
These trace to every hunk of fix_impl.patch.

I put the `step_lastkeyno` parameter back through the prototypes, definitions and callers. The recursion test in get_steps_using_prefix_recurse went from `cur_keyno < final_keyno` (where final_keyno = last keyno in prefix) back to `cur_keyno < step_lastkeyno - 1`.
For HASH partitioning, step_lastkeyno is the key of the last clause. Keys with IS NULL clauses (nullkeys) are not in the prefix, so the expected keyno sequence has gaps. Recursion therefore stops at the wrong point or step generation is wrong. Hash pruning steps come out wrong.

Failing oracle case: src/test/regress||partition_prune
