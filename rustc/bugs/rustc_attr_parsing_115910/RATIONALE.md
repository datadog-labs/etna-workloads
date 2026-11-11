# Adapted injection for Prevent using `#[target_feature]` on lang item functions

Fix: https://github.com/rust-lang/rust/commit/9102816bc4deca950b66cce402ea45573acc8fa0

# Rationale
In 1.99.1 the fix's check moved from `rustc_passes/check_attr.rs::check_target_feature` (hunk `@@ -571,10 +571,36 @@`, which added the `hir::lang_items::extract(attrs)` / `emit_err(LangItemWithTargetFeature{..})` branch for `Target::Fn`) into `compiler/rustc_attr_parsing/src/attributes/codegen_attrs.rs`, `TargetFeatureParser::finalize_check`. That function emitted `TargetFeatureOnLangItem` for `#[lang]`/`#[panic_handler]` items (non-wasm, non-rustdoc). I removed `finalize_check`, restoring the pre-fix behaviour: `#[target_feature]` is silently accepted on lang item functions. The error message/diagnostic hunks (messages.ftl, errors.rs) are left unused.
