# Rationale

File: src/backend/optimizer/plan/subselect.c, function hash_ok_operator().
Traces to the fix.patch hunk that added `opid == RECORD_EQ_OP` to the `ARRAY_EQ_OP` check, so that record_eq is hashable only if op_hashjoinable() says so for the input type. Today's code also lists RANGE_EQ_OP and MULTIRANGE_EQ_OP; I removed only RECORD_EQ_OP.
With it removed, record_eq falls into the generic path. That path treats it as hashable whenever the operator is hashjoinable and strict, even for record types that contain non-hashable columns. The planner then builds a hashed subplan that can't be hashed.

Failing oracle case: src/test/regress||subselect
