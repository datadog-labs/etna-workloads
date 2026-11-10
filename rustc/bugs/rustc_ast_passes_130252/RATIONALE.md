# Adapted injection for Properly deny const gen/async gen fns

Fix: https://github.com/rust-lang/rust/commit/594de02cbacccd3a220c69971e085bfd76a84eac

# Hunk: compiler/rustc_ast_passes/src/ast_validation.rs, AstValidator::visit_fn (const + coroutine check)
Fix hunk `@@ -1418,21 +1418,16 @@` replaced the `ConstAndAsync` error (always reporting "async", even for `gen`/`async gen`) with `ConstAndCoroutine { coroutine_kind: coroutine_kind.as_str(), .. }`.
In 1.99.1 the diagnostic was already renamed/moved to diagnostics.rs; I re-introduced the bug by passing the hardcoded `"async"` instead of `coroutine_kind.as_str()`, so `const gen fn` / `const async gen fn` are reported as "const and `async`".
