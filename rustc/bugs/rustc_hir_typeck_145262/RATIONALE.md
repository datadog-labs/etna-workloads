# Adapted injection for Make sure to treat only param where clauses as inherent

Fix: https://github.com/rust-lang/rust/commit/c2b9a8afa9674f473ac78bc0fad76b18c78b7667

# Hunk: compiler/rustc_hir_typeck/src/method/probe.rs, ProbeContext::consider_probe
Removed the `if matches!(probe.kind, WhereClauseCandidate(_)) { ... normalize self_ty; if !Param => return ProbeResult::NoMatch }` block in the `ObjectCandidate | WhereClauseCandidate` arm.
Re-expresses fix hunk `@@ -1945,6 +1949,29 @@` (the added "WhereClauseCandidate requires that the self type is a param" check). Without it, where clauses with rigid alias self types are treated as inherent candidates.
The first fix hunk (comment only in assemble_inherent_candidates_from_param) is a comment; not reverted.
