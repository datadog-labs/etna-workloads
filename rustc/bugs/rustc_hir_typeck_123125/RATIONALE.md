# Adapted injection for Remove note about iteration count in coerce

Fix: https://github.com/rust-lang/rust/commit/6289ed842897f75f7b1f06aee44f9f123f57077d

# Rationale
Fix hunk `@@ -57,7 +57,8 @@ impl FnCtxt` in compiler/rustc_hir_typeck/src/demand.rs added
`|| self.suggest_returning_value_after_loop(err, expr, expected)` to the suggestion chain.
Re-injection: removed that call from the chain in demand.rs (`emit_type_mismatch_suggestions`), so the
"consider returning a value here" suggestion for while/for loop tail expressions is no longer emitted.
Added `#[allow(dead_code)]` on `suggest_returning_value_after_loop` in fn_ctxt/suggestions.rs (hunk "@@ -1942,6 +1942,91 @@") to keep the build warning-free.
