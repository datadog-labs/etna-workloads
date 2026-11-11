# Rationale

Changed hunk: src/src/ast/rewriter/rewriter_def.h, `rewriter_tpl::process_app`, in the `fr.m_new_child` branch.

Traces to the first hunk of FIX.diff (rewriter_def.h). The fix changed `if (ProofGen)` to `if (ProofGen && !m_pr)`, so a congruence (monotonicity) proof from rewritten children is kept. I reverted it to `if (ProofGen)` and removed the added comment. The rewriter now always replaces the congruence proof with `rewrite(t, t')`. That is not a tautology when the children were rewritten under a substitution with premises, so the proofs are unjustified. The simplifier unit's proof-checking test then fails.

Only this hunk was re-expressed. The other FIX.diff hunks add new features (solve-eqs proofs), so they have no bug to reintroduce.

## Final ./check.sh output
BUILD OK
FAIL simplifier (rc=114)
    ASSERTION VIOLATION
    File: src/src/test/simplifier.cpp
    Line: 521
    Failed to verify: check->check_sat(0, nullptr) == l_false
