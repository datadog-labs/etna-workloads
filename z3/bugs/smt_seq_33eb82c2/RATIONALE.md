# Rationale

Changed hunk: src/src/smt/theory_seq.cpp, theory_seq::assign_eh, negated-prefix branch.

Traces to the FIX.diff hunk at `assign_eh` that replaced
`propagate_non_empty(lit, e1); if (add_prefix2prefix(e, change)) add_atom(e);` with `propagate_not_prefix(e)`.
Pre-fix, a negated prefixof only got the non-emptiness propagation plus the lazy prefix2prefix unfolding,
which was incomplete and let models through where !prefixof(substr(s,0,i), s) was falsely satisfied (issue #1566:
invalid models). In today's code add_prefix2prefix / propagate_automata / add_atom no longer exist (the
automata/retry machinery was removed), so the faithful re-expression is to drop the real axioms
(propagate_not_prefix -> m_ax.add_prefix_axiom) and keep only propagate_non_empty. The negated prefix then has
no semantic axiom, giving the same symptom: "sat" with an invalid model.
The other FIX.diff hunks (dead code removal, suffix axiom rewrite, header) were not reversed: they are cleanups or
have no counterpart in current code.

## check.sh output
    < unsat
    < unsat
    < unsat
    ---
    > sat
    > (error "line 6 column 10: an invalid model was generated")
    > sat
    > (error "line 24 column 10: an invalid model was generated")
    > sat
    > (error "line 32 column 10: an invalid model was generated")
    > sat
    > (error "line 38 column 10: an invalid model was generated")
