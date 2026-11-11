# Adapted injection for Don't ICE when auto trait has assoc ty in old solver

Fix: https://github.com/rust-lang/rust/commit/0919d0714ec49773d3a4c3a589b7651655b1b7c0

# project.rs, assemble_candidates_from_impls
Removed the `_ if tcx.trait_is_auto(trait_ref.def_id) => { span_delayed_bug(...); false }` match arm in the builtin-impl branch, so auto traits with assoc types hit `bug!("unexpected builtin trait with associated type")` again (ICE).
Re-expresses fix hunk `@@ -1202,6 +1202,12 @@ fn assemble_candidates_from_impls` which added `else if tcx.trait_is_auto(...) { span_delayed_bug("associated types not allowed on auto traits"); false }`.
