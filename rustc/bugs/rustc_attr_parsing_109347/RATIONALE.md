# Adapted injection for Skip no_mangle if the item has no name.

Fix: https://github.com/rust-lang/rust/commit/3102722ef4aa61b02f78f98403ceef588ed791ca

# Rationale
1. compiler/rustc_codegen_ssa/src/codegen_attrs.rs, `process_builtin_attrs` (`AttributeKind::NoMangle`): removed the `tcx.opt_item_name(..).is_some()` guard (and its error/delayed-bug else branch) so NO_MANGLE is set unconditionally. Re-expresses fix hunk `@@ -103,7 +103,22 @@ fn codegen_fn_attrs`, which replaced `sym::no_mangle => flags |= NO_MANGLE` with a name check + error.
2. compiler/rustc_attr_parsing/src/attributes/codegen_attrs.rs, `NoMangleParser::ALLOWED_TARGETS`: `Error(Target::Closure)` -> `Allow(Target::Closure)`. In 1.99.1 closures are rejected earlier by target checking (a later-added check that did not exist at the parent commit); allowing them restores parent behaviour where a closure reaches codegen attrs with no_mangle.
