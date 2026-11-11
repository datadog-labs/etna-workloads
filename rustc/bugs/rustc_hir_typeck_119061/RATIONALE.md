# Adapted injection for Make sure all kinds of generators only return unit

Fix: https://github.com/rust-lang/rust/commit/bb33200047722e321480f7e5004a74395804958d

# Rationale
File: compiler/rustc_hir_typeck/src/closure.rs, fn sig_of_closure_no_expectation / supplied_return computation (`FnRetTy::DefaultReturn` match).
Fix hunk `@@ -650,9 +650,10 @@` replaced `Some(Gen(CoroutineSource::Fn)) => unit` with `Gen(_) | AsyncGen(_) => unit`.
Re-injected the old behaviour: only `Gen` with `CoroutineSource::Fn` gets `()` return; `Gen` (other sources) and `AsyncGen` now fall to `ty_infer`, so `async gen fn -> i32`, `gen {..; 1}` etc. are accepted.
