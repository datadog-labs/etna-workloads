# Changed hunk
src/src/ast/euf/euf_egraph.cpp, egraph::merge: when both roots are interpreted, `set_conflict(n1, n2, j)` -> `set_conflict(r1, r2, j)`.

Traces to the FIX.diff hunk in euf_egraph.cpp `merge`/`set_conflict(r1, r2, j)` -> `set_conflict(n1, n2, j)`.
The conflict is recorded on the class roots instead of the merged nodes, so explain() works on the wrong
nodes (m_n1/m_n2 are no longer the original terms, and the congruence/justification path is lost). In test3 of egraph this trips
an assertion in the explanation code (n1->get_decl() == n2->get_decl()) and the test fails.

The other hunks of FIX.diff were not reintroduced: the swap condition and the explain() refactor are already different in this release,
and the SASSERT/theory_seq hunks have no faithful analogue here.

# check.sh final output
BUILD OK
FAIL egraph (assertion violation at euf_egraph.cpp:764)
