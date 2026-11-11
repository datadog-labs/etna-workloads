# Adapted injection for allow opaques to be defined by trait queries

Fix: https://github.com/rust-lang/rust/commit/281c2271bea8dea7085988211d5512a67c659c73

# Rationale
File: compiler/rustc_trait_selection/src/infer.rs, fn `enter_canonical_trait_query`.

Fix hunk `@@ -117,8 +117,9 @@ ... enter_canonical_trait_query`:
`-  self.build_with_canonical(DUMMY_SP, canonical_key);` / `+ .with_opaque_type_inference(DefiningAnchor::Bubble).build_with_canonical(...)`.
The fix let trait queries define opaque types (Bubble anchor). In 1.99.1 that role is played by the typing mode inside the canonical input
(`TypingMode::Typeck { defining_opaque_types_and_generators }`). To restore the buggy behaviour, a `Typeck` mode in the key is replaced by
`TypingMode::non_body_analysis()` (no defining opaques), so trait queries can no longer define opaques. Imports adjusted accordingly
(analogue of hunk #1 import change).
