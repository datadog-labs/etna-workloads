# Rationale
Changed hunk: src/src/math/dd/dd_pdd.cpp, pdd_manager::reset(): removed `m_node_table.reset();`.
Traces to the FIX.diff hunk in dd_pdd.cpp that introduced pdd_manager::reset (reset_op_cache; m_node_table.reset(); m_nodes.reset(); init_nodes). The bug fixed was that resetting the manager with a new level2var did not properly clear state, so stale nodes were reused. Without clearing the node table, stale entries survive the reset and the new nodes/variable order are corrupted (test_reset in pdd fails with an assertion).
(The verbatim hunk cannot apply because the code has since been refactored.)

Final check.sh output summary:
PASS bdd
FAIL pdd (rc=110)
