# Adapted injection for Account for macros

Fix: https://github.com/rust-lang/rust/commit/d23dc2093c2037a3f401d917ddb9e9c8507ef116

# Hunk: compiler/rustc_hir_typeck/src/loops.rs, `CheckLoopVisitor::require_break_cx`
Fix hunk (`@@ -231,7 +231,7 @@ ... rustc_passes/src/loops.rs`): `UnlabeledBlock(block_span) if is_break && block_span.ctxt() == break_span.ctxt()`.
The loops check moved to rustc_hir_typeck; the equivalent guard is `label_span.eq_ctxt(break_span)` on the `UnlabeledBlock` arm. I removed it, so breaks from macro expansions get the "label this block" suggestion even when the block and break have different syntax contexts.
