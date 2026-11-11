# Adapted injection for Suggest to replace tuple constructor through projection

Fix: https://github.com/rust-lang/rust/commit/304ccf45d15153b29c413a84334a9b4aaee23d53

# Rationale
File: compiler/rustc_hir_typeck/src/method/suggest.rs, fn report_no_match_method_error (tail of the function).
Removed the block `// Check if we wrote `Self::Assoc(1)` as if it were a tuple ctor.` (checks SelfSource::QPath, Res::SelfTyAlias, assoc type resolving to a tuple struct with CtorKind::Fn, then suggests the explicit path). This re-expresses fix hunk `@@ -690,6 +690,30 @@ impl<'a, 'tcx> FnCtxt` which added that block. Also reverted the now-unneeded `use rustc_hir::def::{CtorKind, DefKind, Res}` back to `DefKind` (fix hunk 1) and dropped a then-unused `let tcx = self.tcx;`.
