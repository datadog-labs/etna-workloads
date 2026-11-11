# Adapted injection for Don't suggest constraining unstable associated types

Fix: https://github.com/rust-lang/rust/commit/9313580e2aa4f7463d9413169fe5d70eba7a7428

# Rationale
File: compiler/rustc_trait_selection/src/error_reporting/traits/suggestions.rs, fn `suggest_restriction`.
Fix hunk `@@ -136,7 +136,10 @@` added `|| tcx.lookup_stability(projection.def_id).is_some_and(|stab| stab.is_unstable())` to the early-return condition. I removed that unstable-check (in 1.99.1 it uses `projection.kind`), restoring the parent behaviour of suggesting constraining unstable associated types.
