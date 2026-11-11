# Adapted injection for Avoid an ICE in diagnostics

Fix: https://github.com/rust-lang/rust/commit/d3a89cd214a41e8c339db0baf6fc7acb463e64ec

# Rationale
File: compiler/rustc_borrowck/src/diagnostics/mutability_errors.rs, fn `is_error_in_trait`.
Replaced the bounds-checked `sig.decl.inputs.get(local.index() - 1)` with direct indexing `&sig.decl.inputs[local.index() - 1]` in the let-chain.
Re-expresses fix hunk `@@ -698,7 +698,7 @@` (`inputs[local.index() - 1]` -> `*inputs.get(local.index() - 1)?`): in 1.99.1 the code moved and uses a let-chain; the bug is the unchecked index, which panics when the impl method has more args than the trait method.
