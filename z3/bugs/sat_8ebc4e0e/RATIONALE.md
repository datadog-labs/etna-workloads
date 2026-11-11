# Rationale
Changed hunk: `proof_trim::del()` in src/src/sat/sat_proof_trim.cpp (FIX.diff hunk replacing the literal-set
`del(cl)` with `detach(cl, cp)` and the "record only if something was detached / ignore after conflict" logic).
The reintroduced bug: deletions are always pushed onto the trail, even after the conflict is set or when the
clause was never added (detach's result is ignored). trim() then revives never-added clauses, which end in
"proof trimming: internal error, the clause ... used by the proof was never added".

Final ./check.sh: BUILD OK; FAIL proof_replay (rc=134) — default_exception: proof trimming: internal error,
the clause -2 3 5 used by the proof was never added.
