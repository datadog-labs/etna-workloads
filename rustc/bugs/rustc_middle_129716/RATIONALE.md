# Adapted injection for Consider synthetic closure bodies to be typeck children

Fix: https://github.com/rust-lang/rust/commit/63405fc2b3a15194e47712b738275c6d76de6b27

# Rationale
compiler/rustc_middle/src/ty/util.rs, `TyCtxt::is_typeck_child`.
Fix hunk `@@ -571,7 +571,10 @@ impl<'tcx> TyCtxt<'tcx>` added `DefKind::SyntheticCoroutineBody` to the
`matches!(.., Closure | InlineConst | SyntheticCoroutineBody)`. In 1.99.1 it is a match arm
`DefKind::Closure | DefKind::SyntheticCoroutineBody => true`; I split it so SyntheticCoroutineBody => false again.
