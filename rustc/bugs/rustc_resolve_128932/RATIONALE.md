# Adapted injection for skip updating when external binding is existed

Fix: https://github.com/rust-lang/rust/commit/df019a9f46d58fcb1b32ee69022a294a93e1a0a7

# Rationale
File: compiler/rustc_resolve/src/build_reduced_graph.rs, fn build_reduced_graph_for_extern_crate (extern prelude update, `Entry::Occupied` arm).

Fix hunk `@@ -913,14 +914,21 @@` replaced the unconditional `entry.binding = Some(imported_binding);` with
`if !entry.is_import() { entry.binding = Some(imported_binding) } else if ident.name != kw::Underscore { span_delayed_bug(...) }`.
In 1.99.1 this is `if entry.item_decl.is_some() { span_delayed_bug } else { entry.item_decl = Some(..) }`.
I removed the check so the existing item binding is always overwritten and no delayed bug is emitted (old behaviour).
