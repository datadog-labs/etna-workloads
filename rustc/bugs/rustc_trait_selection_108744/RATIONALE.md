# Adapted injection for Don't ICE when encountering bound var in builtin copy/clone bounds

Fix: https://github.com/rust-lang/rust/commit/32f1f0149924dc15af804def867c480eab26fb52

# Rationale
File: compiler/rustc_trait_selection/src/traits/select/candidate_assembly.rs, fn assemble_builtin_copy_clone_candidate.

In 1.99.1 the builtin Copy/Clone type match moved from select/mod.rs to candidate_assembly.rs. I removed the `ty::Bound(..) => {}` arm and put `ty::Bound(..)` in the `bug!("asked to assemble builtin bounds of unexpected type")` arm.

This re-expresses the fix hunk `@@ -2269,9 +2269,10 @@`. That hunk changed `ty::Placeholder(..) | ty::Bound(..) | ty::Infer(Fresh*) => bug!(...)` to `ty::Bound(..) => None` plus a separate bug! arm for the Fresh types. Reversing it makes a bound var in `for<T> T: Copy` ICE again.

The other fix hunks are not re-expressed:
- The comment-only hunk has no behavioural effect.
- The Placeholder hunk is already handled by the fallback arm in 1.99.1, and the Placeholder-to-bug! half of the old behaviour was not reintroduced.
