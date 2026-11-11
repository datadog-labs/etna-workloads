# Adapted injection for Guard SizeSkeleton::compute against stack overflow

Fix: https://github.com/rust-lang/rust/commit/7a900df1b9a36edea7231b90a25dd9ed0ddbe617

# Rationale
File: compiler/rustc_middle/src/ty/layout.rs, `SizeSkeleton::compute_inner`.
Removed the recursion-limit guard (`if depth >= recursion_limit.0 { emit RecursionLimitReachedSizeSkeleton; return Err(ReferencesError) }`).
Re-expresses fix hunk `@@ -332,9 +332,38 @@ impl<'tcx> SizeSkeleton<'tcx>` (the `compute_inner` hunk adding "Bail out if we've recursed too deeply (issue #156137)"). Without it, the cyclic alias `Thing<T>` recurses unboundedly and overflows the stack.
The depth parameter and plumbing remain (already present in 1.99.1); only the check is removed. Other hunks (span plumbing, error struct) are refactoring needed by the guard and are left as-is.
