# Adapted injection for only find segs chain for missing methods when no available candidates

Fix: https://github.com/rust-lang/rust/commit/ade33b02f237d484bef950ebf550bc12d49313d1

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, the caller of `lookup_segments_chain_for_no_match_method` (~line 1081).
Re-expresses fix hunk `@@ -1371,9 +1374,32 @@`: `if !find_candidate_for_method { self.lookup_segments_chain_for_no_match_method(...) }`.
The pre-fix code ran the segments-chain lookup unconditionally (when no unsatisfied predicates), even when the
"the method was found for ..." note was already emitted. Now the guard is `if true || !find_candidate_for_method`, restoring that.
The other hunks (introducing the flag) are already present in 1.99.1 and left untouched.
