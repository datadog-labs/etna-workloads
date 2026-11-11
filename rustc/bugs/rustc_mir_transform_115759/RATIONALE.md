# Adapted injection for Strip `OpaqueCast` during `RevealAll`.

Fix: https://github.com/rust-lang/rust/commit/6ea2db7c2d78182fabf66a8c6ffc856446e1cf81

# Rationale
File: compiler/rustc_mir_transform/src/post_analysis_normalize.rs (successor of reveal_all.rs), `visit_place`.
The fix hunk `@@ -25,6 +25,25 @@ impl MutVisitor for RevealAllVisitor` added `visit_place` that filters out
`ProjectionElem::OpaqueCast` ("After the RevealAll pass ... we don't need these projections anymore").
In 1.99.1 that logic lives in PostAnalysisNormalizeVisitor::visit_place under `if !next_trait_solver_globally()`.
I changed the condition to `if false`, so OpaqueCast is no longer stripped (pre-fix behaviour); codegen/const-eval then hit the OpaqueCast bug!() paths (the other fix hunks in codegen_ssa, cranelift, const_eval already match the post-fix code).
