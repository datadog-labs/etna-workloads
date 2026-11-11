Changed files: src/src/ast/rewriter/seq_rewriter.{cpp,h}

Traces to the seq_rewriter hunks of FIX.diff (get_lengths / mk_seq_extract). The code has since been
refactored: the extract offset logic now lives in extract_push_offset, and get_lengths is already the
bool-returning version. Undoing the fix there means:
- get_lengths gains an `other` vector again. Non-length, non-numeral summands go into `other` instead of making
  it fail (reverts the `return false` / bool return hunks). The 3-arg get_lengths stays as a wrapper that fails
  if `other` is non-empty, so the other callers are unchanged.
- extract_push_offset collects `other` and adds it back into the new offset (reverts the removal of the
  `for (expr* rhs : other) t2 = add(t2, rhs)` hunk). It also treats the lengths as removable prefix, which is
  unsound for arbitrary summands, so it gives a wrong rewrite.

The theory_seq itos hunk is not reintroduced. The axiom code was rewritten (ast/seq/seq_axioms.cpp) and already
has both directions.

Final check.sh: FAIL z3test:smt2/2415.smt2 (rc=1): expected "unsat", got "sat (error ... an invalid model was generated)".
