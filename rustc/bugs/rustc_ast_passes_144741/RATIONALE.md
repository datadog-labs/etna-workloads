# Adapted injection for fix: Error on illegal `[const]`s inside blocks within legal positions

Fix: https://github.com/rust-lang/rust/commit/7d78968bd053eb7811126b2bad991579fb78cc3a

# Hunk
compiler/rustc_ast_passes/src/ast_validation.rs, `impl Visitor for AstValidator`: removed `fn visit_anon_const`
(which wrapped `visit::walk_anon_const` in `with_tilde_const(Some(TildeConstReason::AnonConst{..}))`).
Re-expresses fix hunk `@@ -1623,6 +1631,13 @@ ... fn visit_anon_const(&mut self, anon_const: &'a AnonConst)`
(added by the fix). Without it, `[const]` bounds inside blocks in anon consts (e.g. `impl [const] Trait` in a let
inside a const generic arg) are no longer rejected (issue #132067).
Other fix hunks (struct/enum/union reasons) already exist in 1.99.1 and were left as-is; the AnonConst variant is now unused (warning only).
