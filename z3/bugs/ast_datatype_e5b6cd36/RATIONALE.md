Changed hunk: src/src/ast/datatype_decl_plugin.cpp, util::is_recursive_core.
Traces to the FIX.diff hunks in datatype_decl_plugin.cpp (the debug prints and the .h helper are not needed). The fix keys the cycle-detection map by datatype name. I put it back to keying by the sort (obj_map<sort,status>, with find/insert on the sort and s0 == s2). Different instantiations of a parametric datatype then count as different nodes, so cycle detection fails for #5482.
check.sh: FAIL z3test:issues/5482.smt2 (rc=139, crash).
