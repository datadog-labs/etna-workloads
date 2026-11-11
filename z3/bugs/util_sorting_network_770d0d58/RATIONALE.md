# Rationale
Changed hunk: src/src/util/sorting_network.h, in the dsmerge clause generation (`if (m_t != LE)` block).
Traces to the sorting_network.h hunk of FIX.diff, which added the clauses
`~out[k] \/ bs[k-a]` (when a <= k) and `~out[k] \/ as[k-b]` (when b <= k).
I removed them. Without these clauses the merge encoding is too weak for the "out[k] implies input" direction
when k exceeds one side's size, so the network admits spurious models and the test sees sat where unsat is expected.

Final ./check.sh output:
BUILD OK
FAIL sorting_network (rc=114)
    ASSERTION VIOLATION  File: src/src/test/sorting_network.cpp Line: 603
    Failed to verify: l_false == solver.check()
