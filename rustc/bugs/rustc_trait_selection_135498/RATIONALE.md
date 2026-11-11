# Adapted injection for Prefer lower TraitUpcasting candidates

Fix: https://github.com/rust-lang/rust/commit/bf545ce2fee9f1fef0fd9e63e46b5aab5de61465

# Hunks
1. compiler/rustc_trait_selection/src/traits/select/mod.rs, winnow/candidate_should_be... (the function with the `// Same for upcasting.` block): removed the block computing `upcast_bound` (min index of TraitUpcastingUnsizeCandidate). Re-expresses fix hunk `@@ -1895,6 +1895,18 @@` ("Same for upcasting." / `try_reduce(... c1.min(c2))`). Without it, two upcast candidates are ambiguous.
2. compiler/rustc_trait_selection/src/solve/select.rs, candidate_should_be_dropped_in_favor_of: removed the `TraitUpcasting(a)` vs `TraitUpcasting(b)` => `a >= b` arm. Re-expresses fix hunk `@@ -117,6 +117,10 @@`.
The fix's other hunks (adding the index to the enum, passing idx) are left in place; they are inert without the preference logic. The type_ir hunk didn't apply but is not needed.
