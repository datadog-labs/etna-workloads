Reproducer: `repro.sql` (join2-11.1 minus the optimization_control call, which is not needed).
A LEFT JOIN against a view whose column is a constant scalar subquery (`SELECT count(*) FROM t1`, computed in OP_Once).
The buggy shell's OP_IfNullRow writes NULL into the wrong register, so the last row prints `0|2|2|` (w is NULL).
The clean shell prints `0|2|2|3`.
