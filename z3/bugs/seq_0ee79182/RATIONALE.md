# Rationale
Single hunk in src/src/ast/rewriter/seq_rewriter.cpp, mk_re_loop, tracing to the first hunk of FIX.diff
(the `lo2 > hi2` case). The fix makes a loop with lo > hi the empty regex. I restored the pre-fix behaviour,
rewriting it to `(loop a lo2 lo2)`. An ill-formed range such as (loop a 3 2) then matches exactly 3 copies
instead of nothing, so z3test smt2/3911.smt2 returns sat instead of unsat.

check.sh output:
BUILD OK
FAIL z3test:smt2/3911.smt2 (rc=0)
    < unsat
    ---
    > sat
