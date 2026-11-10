# Adapted injection for create dummy placeholder crate to prevent compiler

Fix: https://github.com/rust-lang/rust/commit/0fd2a70b90081c9536b89c95ca7f03755c13e9b4

# Rationale
File: compiler/rustc_expand/src/base.rs, `impl MacResult for DummyResult`.
Removed the `make_crate` override (which returns a dummy `ast::Crate`). This re-expresses the fix hunk
`@@ -640,6 +641,10 @@ impl MacResult for DummyResult` which added
`fn make_crate(self: Box<DummyResult>) -> Option<ast::Crate> { Some(DummyAstNode::dummy()) }`.
Without it the trait default returns None, so a recursion-limit-hit crate-level attribute expansion has no placeholder crate and the compiler ICEs.
(The import hunk is moot: 1.99.1 builds the dummy crate inline.)
