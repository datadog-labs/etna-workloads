# Adapted injection for diagnostics: fix ICE in closure signature mismatch

Fix: https://github.com/rust-lang/rust/commit/fb55b5dcf33c3f134a41851771c3b13710a8a048

# Rationale
File: compiler/rustc_trait_selection/src/diagnostics.rs (was errors.rs upstream), `impl Subdiagnostic for AdjustSignatureBorrow::add_to_diag`.
Re-expresses fix hunks `@@ -153,10 +153,10 @@` and `@@ -166,10 +166,10 @@`: the fix renamed the fluent arg `len` to `borrow_len` / `remove_borrow_len`. I restored the shared name `len` in both variants (diag.arg("len", ...) and `{$len -> ...}`), so the second arg overwrites the first and the diagnostic ICEs/misrenders when both suggestions are emitted.
