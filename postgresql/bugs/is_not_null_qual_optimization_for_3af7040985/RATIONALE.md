# Rationale

Two hunks were reverted. The fix's other hunks (apply_child_basequals, relnode.c, comments) were left alone, because these two conditions are enough to bring the bug back.

1. `src/backend/optimizer/plan/initsplan.c`, `add_base_clause_to_rel()`. This traces to the initsplan.c hunk of fix.patch. The always-true/always-false transformation is made unconditional again (`if (true)`). The fix limited it to `!rte->inh || relkind == RELKIND_PARTITIONED_TABLE`. For a non-partitioned inheritance parent, the original qual can now be dropped or replaced with constant FALSE, so `apply_child_basequals` never sees it.

2. `src/backend/optimizer/util/plancat.c`, `get_relation_info()`. This traces to the plancat.c hunk of fix.patch. `rel->notnullattnums` is populated again for non-partitioned inheritance parents (`if (true)`). The fix left it empty there. Some children may lack the NOT NULL constraint, so `IS NULL` and `IS NOT NULL` quals on the parent are wrongly judged always true or false and applied to every child.

Failing oracle case: `src/test/regress||predicate`.
