# Adapted injection for Fix error report for size overflow from transmute

Fix: https://github.com/rust-lang/rust/commit/00010eda8b2828da967a562c093c6723889203ae

# Rationale
One hunk: compiler/rustc_transmute/src/layout/tree.rs, `impl From<&LayoutError> for Err`.
Fix hunk `@@ -196,6 +198,7 @@ ... fn from(err: &LayoutError<'tcx>)` added `LayoutError::SizeOverflow(..) => Self::SizeOverflow,`
before the catch-all `err => unimplemented!(..)`. In 1.99.1 the match is exhaustive, so I re-expressed the
pre-fix behaviour by making SizeOverflow hit `unimplemented!("{:?}", err)` (ICE) instead of mapping to `Err::SizeOverflow`
(which then yields Reason::{Src,Dst}SizeOverflow and the "too big" error message).
