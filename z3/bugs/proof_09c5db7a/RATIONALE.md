# Rationale

The release already contained most of the fix's code. Only the pinning hunk could be undone cleanly.

Changed hunk: `src/sat/smt/euf_proof_checker.h`, `smt_proof_checker::mk_literal`.
It traces to the FIX.diff hunk in `euf_proof_checker.h` that introduced `mk_literal` and pinned each mapped expression in `m_pinned`.
I reverted that to the old behaviour: `sat::literal(e->get_id(), sign)` with no pinning.
Literals are again mapped to SAT variables by raw expression id without keeping the expressions alive.
An unreferenced folded literal can then be freed and its id reused. Later occurrences of the literal then get a different variable, which is the bug the fix described.
The `m_pinned` and `m_is_pinned` members and the constructor initializer are left in place but unused.
The unit `proof_replay` now fails: the nopp log is not verified natively and ends in `(verified-smt`.

Final ./check.sh output (PASS/FAIL lines):
```
FAIL proof_replay (rc=114)
```
