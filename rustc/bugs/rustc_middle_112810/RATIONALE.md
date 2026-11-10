# Adapted injection for Don't ICE on unnormalized struct tail in layout computation

Fix: https://github.com/rust-lang/rust/commit/dd620aa73aac7dc219774c8e09fed13853d8af58

# Rationale
File: compiler/rustc_middle/src/ty/layout.rs, `SizeSkeleton::compute`.
Re-expresses hunk `@@ -318,7 +318,13 @@ impl<'tcx> SizeSkeleton<'tcx>` (`Err(err) => err` became `Err(err @ LayoutError::Unknown(_)) => err` plus early return for `Cycle | SizeOverflow | NormalizationFailure`).
In 1.99.1 the fall-through arm is `Err(err @ LayoutError::TooGeneric(_)) => err`; I added `NormalizationFailure(..)` to it and removed it from the early-return list, so normalization failures again fall through to the structural SizeSkeleton computation instead of returning the error.
The layout_of_uncached hunks in rustc_ty_utils already differ structurally in 1.99.1 and were left untouched.
