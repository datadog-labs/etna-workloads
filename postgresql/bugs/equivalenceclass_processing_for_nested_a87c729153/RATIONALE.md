# Rationale

File: src/backend/optimizer/path/equivclass.c, function add_child_rel_equivalences().

Traces to the fix.patch equivclass.c hunk, which made child-EM generation work when parent_rel is itself a child (nested appendrels). The old code skipped the parent-relids check for non-base rels. The current code matches EC members against the top parent's relids (`top_parent_relids`). I changed the member test to `bms_is_subset(cur_em->em_relids, parent_rel->relids)`. EC members refer to the topmost parent, so when parent_rel is an intermediate child this test fails. No child EMs are then built for nested append relations, and the planner can't find the EC member it needs (e.g. for MergeAppend sort pathkeys).

Failing oracle case: src/test/regress||union
