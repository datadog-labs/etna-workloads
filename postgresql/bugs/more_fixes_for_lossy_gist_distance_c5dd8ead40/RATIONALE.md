# Rationale

1. src/backend/optimizer/plan/createplan.c, create_indexscan_plan(): traces to the createplan.c hunk
   replacing the equivalence-member lookup with exprType(). Restored the old logic: find the
   EquivalenceMember for the ORDER BY expression in pathkey->pk_eclass and use em->em_datatype.
   For commuted ORDER BY expressions the expression is not in the EC, so em is NULL and the
   planner crashes (the original bug).
2. src/backend/executor/nodeIndexscan.c, ExecInitIndexScan(): traces to the nodeIndexscan.c hunk
   that replaced get_ordering_op_properties() with exprType(orderbyexpr). Restored the
   get_ordering_op_properties() datatype lookup.

Failing oracle case: src/test/regress||gist
