# Adapted injection for Do not repeat idx

Fix: https://github.com/rust-lang/rust/commit/bbfbecd59ff99b51d1ccf7764641ef32209b9dad

In compiler/rustc_hir_typeck/src/fn_ctxt/checks.rs (suggestion builder for replaced args, the loop over `matched_inputs`), removed `prev += 1;` after a successful `provided_arg_tys.get(idx)`.
Re-expresses fix hunk `@@ -1156,14 +1156,15 @@` (`idx = match provided_idx { Some(p) => p+1, None => idx + 1 }`): the fix makes the index advance for consecutive unmatched args; without the increment the same idx is repeated.
