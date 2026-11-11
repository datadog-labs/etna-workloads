# Adapted injection for Fix bad suggestion for clone/is_some in field init shorthand

Fix: https://github.com/rust-lang/rust/commit/64f6e4f21ccd8e0ed1f4bb32abe525b4f6ab87c1

File: compiler/rustc_hir_typeck/src/fn_ctxt/suggestions.rs
1. Clone-suggestion function (`consider using clone here`): removed the `hir_maybe_get_struct_pattern_shorthand_field` match, always suggests `.clone()`. Re-expresses fix hunk `@@ -985,13 +985,18 @@` (the `": {}.clone()"` shorthand case).
2. Option::is_some suggestion function: removed shorthand match, always suggests `.is_some()`. Re-expresses hunk `@@ -1153,13 +1158,17 @@` (`": {}.is_some()"`). (The span_suggestion_verbose vs span_suggestion change was left verbose.)
Result: in `Foo { t }` shorthand, suggestion yields `t.clone()` instead of `t: t.clone()`.
