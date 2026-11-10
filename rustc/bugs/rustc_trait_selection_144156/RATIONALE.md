# Adapted injection for Check coroutine upvars and in dtorck constraint

Fix: https://github.com/rust-lang/rust/commit/d47150111d8f76b900d23e314c1b63093361e740

# Rationale
File: compiler/rustc_trait_selection/src/traits/query/dropck_outlives.rs, fn dtorck_constraint_for_ty_inner, `ty::Coroutine` arm.
Fix hunk `@@ -319,39 +319,65 @@ pub fn dtorck_constraint_for_ty_inner` added an `else` branch to `if needs_drop { ... }` that recurses
(`dtorck_constraint_for_ty_inner(.., depth + 1, ty, constraints)`) over `args.upvar_tys()` so upvars are still drop-live
when no witness type needs drop. I removed that `else` branch, restoring the buggy behaviour: upvars are not required drop-live
in that case (issue 144155, missing borrowck error).
