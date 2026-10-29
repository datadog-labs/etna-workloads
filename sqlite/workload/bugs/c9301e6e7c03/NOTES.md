Reproducer for the constant-propagation affinity bug (ticket 82ac75ba0093e5dc).
t0.c0 holds text '0'; view v0.c0 is CAST(0 AS INT). With the bug, constant
propagation substitutes the CAST expression (which has affinity) into the join
comparison, so the join wrongly returns a row. The clean shell returns no rows.
