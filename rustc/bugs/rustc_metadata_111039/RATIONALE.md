# Adapted injection for Encode def span for foreign RPITITs

Fix: https://github.com/rust-lang/rust/commit/ed468eebf6e852b80eeed6997c67444268795faa

# Rationale
File: compiler/rustc_metadata/src/rmeta/encoder.rs, function `encode_def_ids` (call site of `should_encode_span`).

Fix hunk `@@ -837,11 +837,12 @@ fn should_encode_span`: moved `DefKind::ImplTraitPlaceholder` from the `false` arm to the `true` arm, so def spans of RPITIT placeholders are encoded into metadata.
In 1.99.1 `DefKind::ImplTraitPlaceholder` no longer exists; RPITITs are synthesized `DefKind::AssocTy` items (identified by `tcx.opt_rpitit_info`). The re-injection skips encoding `def_span` when `opt_rpitit_info(def_id)` is Some, so foreign RPITITs have no def span again.
