# Adapted injection for remove invalid suggestion of into_iter for extern macro

Fix: https://github.com/rust-lang/rust/commit/c45463ec8b2675df903b2436d4baf959d801aa08

# Hunk: compiler/rustc_hir_typeck/src/method/suggest.rs, FnCtxt::report_no_match_method_error (impl_into_iterator_should_be_iterator branch)
Fix hunk `@@ -905,11 +905,13 @@` wrapped the "call `.into_iter()` first" suggestion in `if !span.in_external_macro(...)`.
On 1.99.1 the code is `if !span.in_external_macro(..) && let Some(method_name) = self.preferred_iterator_method(..)`.
I dropped the `in_external_macro` condition, so the suggestion is emitted again for spans from external macros.
