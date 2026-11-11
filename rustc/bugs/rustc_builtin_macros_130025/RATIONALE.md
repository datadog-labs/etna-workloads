# Adapted injection for Allow `missing_docs` lint on the generated test harness

Fix: https://github.com/rust-lang/rust/commit/a1a8627dd789bd7444c78b7a5d360328709a54eb

# Rationale
File: compiler/rustc_builtin_macros/src/test_harness.rs, fn mk_main.
In 1.99.1 the generated `main` carries `#[doc(hidden)]` (which also suppresses missing_docs), a later
evolution of the fix's `#[allow(missing_docs)]` (hunks `@@ -326,6 +326,8 @@ fn mk_main` adding `missing_docs_attr`
and `@@ -355,7 +357,7 @@` `attrs: thin_vec![main_attr, coverage_attr, missing_docs_attr]`).
I removed the `doc_hidden_attr` creation and its use in the attrs list, restoring the parent behaviour: the
generated harness `main` has no attribute silencing missing_docs, so `-Dmissing_docs --test` errors.
The symbol.rs hunk (adding `missing_docs`) needs no re-expression.
