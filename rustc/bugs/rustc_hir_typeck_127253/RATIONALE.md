# Adapted injection for Fix incorrect suggestion for extra argument with a type error

Fix: https://github.com/rust-lang/rust/commit/9f32459c988dec799458f304bbc49ed5dc6ef772

# Rationale
File: compiler/rustc_hir_typeck/src/fn_ctxt/checks.rs, fn `maybe_optimize_extra_arg_suggestion` (formerly inline in report_arg_errors).
Fix hunk `@@ -951,6 +951,32 @@` added `if let [Error::Extra(provided_idx)] = &errors[..] { ... remove_idx_is_perfect ... errors = vec![Error::Extra(..)] }`,
which re-picks the extra argument to remove (the one with the error type). In 1.99.1 this lives in the method; I emptied its body, restoring the pre-fix behaviour (suggest removing the originally detected extra arg).
