# Adapted injection for Use `cfg_attr` AST placeholder AST `cfg_attr_trace` for diagnostics

Fix: https://github.com/rust-lang/rust/commit/f80e3ac4ed1e1df2c337cbf7b231cb72ec4e3b7a

# Rationale
In 1.99.1 the lint is a `#[derive(Diagnostic)]` struct in the resolver, not in rustc_lint, so the fix's rustc_lint hunks map there.

1. compiler/rustc_resolve/src/diagnostics/mod.rs, `struct UnusedExternCrate`: re-expresses fix hunks `@@ -3051,7 +3051,9 @@ ... UnusedExternCrate` in lints.rs and messages.ftl (`.label = unused`, `.suggestion = remove the unused \`extern crate\``). I removed the `#[label("unused")] span` field, restored the suggestion text "remove it", and dropped `style = "verbose"`.
2. compiler/rustc_resolve/src/check_unused.rs, `report_unused_extern_crate_items`: re-expresses `@@ -154,6 +154,7 @@` (`+ span: extern_crate.span,`). I removed that field initializer.
