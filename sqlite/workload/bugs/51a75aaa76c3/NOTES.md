repro.sql runs json_group_array(json(j)) as a window function with ROWS frames (1 PRECEDING..1 FOLLOWING, and 2 PRECEDING..1 PRECEDING) over a 4-row table.
The buggy shell lacks the OP_Column cursor remap for expression arguments in windowAggStep, so the aggregate reads the wrong row.
The buggy output has duplicated or shifted elements, e.g. `[{"a":1},{"a":1}]` instead of `[{"a":1},{"b":2}]`. The clean shell gives the correct arrays.
