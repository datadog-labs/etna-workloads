# Rationale
Two hunks re-introduce the bug fixed in FIX.diff (#5454):

1. src/sat/smt/array_axioms.cpp, assert_select_store_axiom: re-added the early return
   `if (select->get_arg(0) != store && root(select arg0) == root(store)) return false;`
   (removed by the first hunk of FIX.diff). It wrongly skips the select-store axiom.
2. src/sat/smt/array_solver.cpp, propagate_parent_select_axioms: restored the filter so
   only const/map lambdas get select axioms propagated (removed by the second hunk of FIX.diff).

Final ./check.sh output: `FAIL z3test:issues/5454.smt2 (rc=1)`
