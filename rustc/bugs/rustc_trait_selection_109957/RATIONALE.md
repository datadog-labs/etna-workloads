# Adapted injection for account for self type when looking for source of unsolved ty var

Fix: https://github.com/rust-lang/rust/commit/b904ce94a23744032f930841b6fecb6ac2620cd9

File: compiler/rustc_trait_selection/src/error_reporting/infer/need_type_info.rs, FindInferSourceVisitor::visit_expr (GenericArg source).
Removed the `if generics.has_own_self() { argument_index += 1; }` adjustment (moved/renamed from the fix's
`@@ -1191,11 +1191,14 @@` hunk: `if generics.parent.is_none() && generics.has_self { argument_index += 1; }`).
Without it the index ignores the Self param, so the wrong type parameter (`Self`/`'a`) is named in the error.
