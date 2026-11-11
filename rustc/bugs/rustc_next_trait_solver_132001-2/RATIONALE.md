# Adapted injection for normalizes-to disable infer var check

Fix: https://github.com/rust-lang/rust/commit/b64b25b99e738f4c68a83f987b203979eaad4fbf

# Rationale
One hunk: compiler/rustc_next_trait_solver/src/solve/eval_ctxt/mod.rs, `evaluate_added_goals_and_make_canonical_response`.

Fix hunk re-expressed: `@@ -165,12 +165,21 @@` in rustc_next_trait_solver/src/solve/eval_ctxt/canonical.rs, which wrapped the
"too many non-region inference variables -> overflow" check in `if !self.is_normalizes_to_goal { ... }`.
In 1.99.1 that file/check no longer exists (code moved to canonical/mod.rs and the check was gone), so I re-added the
pre-fix behaviour: after `canonicalize_response`, bail with Overflow if non-region canonical vars > recursion_limit,
applied unconditionally (including NormalizesTo goals), hiding inference constraints (#131969).
The coherence.rs hunks (derive Debug / instrument) are non-functional and not re-expressed.
