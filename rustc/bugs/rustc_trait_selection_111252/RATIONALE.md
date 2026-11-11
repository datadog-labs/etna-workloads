# Adapted injection for Normalize consistently for specializations

Fix: https://github.com/rust-lang/rust/commit/fafe9e71d5c949c41a5a562e44cc40d72c5f7244

# Rationale
File: compiler/rustc_trait_selection/src/traits/specialize/mod.rs, fn `fulfill_implication`.
Removed the `ocx.normalize(...)` of `source_trait_ref` (and the delayed-bug/early-return on failed normalization) at the start of `fulfill_implication`. Normalization is now done only in `specializes`, not in `translate_args` path.
Re-expresses fix hunk `@@ -178,6 +166,7 @@ fn fulfill_implication` / `@@ -185,6 +174,22 @@` which added
`let source_trait_ref = match traits::fully_normalize(... source_trait_ref)` inside fulfill_implication (so that normalization is consistent for both callers; the old code only normalized in `specializes`, hunk `@@ -153,20 +152,9 @@`).
The other hunks (adding source_impl param) are signature plumbing; source_impl is still passed but now unused except in nothing (the param stays; harmless).
