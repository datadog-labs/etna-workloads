# Adapted injection for Properly track the depth when expanding free alias types

Fix: https://github.com/rust-lang/rust/commit/341f12df67946faf630e6a656f12e504e9721d44

# Rationale
File: compiler/rustc_middle/src/ty/util.rs, `FreeAliasTypeExpander::fold_ty`.
Removed the `self.depth -= 1;` after folding the expanded alias body, so depth grows monotonically across siblings instead of tracking nesting.
Re-expresses fix hunk `@@ -1052,9 +1052,11 @@ impl<'tcx> TypeFolder<TyCtxt<'tcx>> for FreeAliasTypeExpander<'tcx>` (added `self.depth -= 1; ty`).
