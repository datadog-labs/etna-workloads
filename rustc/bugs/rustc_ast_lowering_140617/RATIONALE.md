# Adapted injection for Report the `unsafe_attr_outside_unsafe` lint at the closest node

Fix: https://github.com/rust-lang/rust/commit/f4e1ec111c016f1dbbedb2628a30e9ce20d8e5f1

# Rationale
File: compiler/rustc_ast_lowering/src/lib.rs, `lower_attrs_vec` (delayed-lint closure).
In 1.99.1 the `check_attribute_safety` logic moved to rustc_attr_parsing, and the lint is buffered as a delayed lint at the HirId of the attributed item (the fix's analog of passing `self.lint_node_id` / `self.cx.current_expansion.lint_node_id` instead of `ast::CRATE_NODE_ID`; fix hunks `@@ -185,7 +191,7 @@ check_attribute_safety`: `-ast::CRATE_NODE_ID, +id`).
The injection restores the old behaviour: `unsafe_attr_outside_unsafe` is attached to the crate root (`hir::CRATE_HIR_ID`) rather than the closest node, so `#[allow(..)]` on an enclosing module has no effect (issue 140602).
