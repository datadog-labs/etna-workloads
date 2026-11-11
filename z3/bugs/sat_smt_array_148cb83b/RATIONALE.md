# Rationale

Changed hunk (src/src/sat/smt/array_model.cpp, solver::add_value): removed
`if (d && !fi->get_else()) fi->set_else(values.get(d->get_root_id()));`.

Traces to the FIX.diff hunk in array_model.cpp add_value that added exactly this
default-based else assignment (using get_default(v), the merged default class from
collect_defaults/mg_merge). Without it, array values that are congruent modulo stores
do not take their shared default as else value, so the model picks an else value
heuristically and differs between such arrays; model validation fails (issue 5482).

Final ./check.sh output:
BUILD OK
FAIL z3test:issues/5482.smt2 (rc=1)
    1,9c1,1219
    < sat
    < unsat
    < unsat
    < unsat
    < unsat
    < unsat
    < unsat
    < unsat
    < unsat
    ---
    > Failed to validate b29 1183: (= (store (store #667 node$type!val!1 #625) node$type!val!3 (c_msg$type gnte data$type!val!3)) (store chan2!51 node$type!val!2 (c_msg$type inv #1180))) false
    > (sat
    > 1: -1 none @1
    >     7 binary 1@1
