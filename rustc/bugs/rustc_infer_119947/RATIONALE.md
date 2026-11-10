# Adapted injection for Make sure to instantiate placeholders correctly in old solver

Fix: https://github.com/rust-lang/rust/commit/24c1f4aa802bc6b9c3710baa4464e691b5b13bb2

File: compiler/rustc_infer/src/infer/canonical/query_response.rs, fn query_response_instantiation_guess (the CanonicalVarValues::instantiate closure).
Re-expresses fix hunks `@@ -483,7 +483,13 @@` and `@@ -491,9 +497,11 @@`: removed the `info.universe() != ROOT` branch (instantiate non-root-universe vars) and replaced the `.expect("expected placeholder to be unified with itself during response")` fallback for placeholders with the old `instantiate_canonical_var(...)` call, so placeholders get fresh placeholders instead of the input's.
