# Adapted injection for Account for object unsafe traits

Fix: https://github.com/rust-lang/rust/commit/78ef94618b037e18d01644638eaf41ecfa5def04

# Rationale
File: compiler/rustc_hir_analysis/src/hir_ty_lowering/dyn_trait.rs, fn maybe_suggest_impl_trait (moved from astconv/lint.rs).
Removed the `pre` prefix ("`Trait` is dyn-incompatible, ") from the return-type `impl Trait` suggestion message.
Re-expresses fix hunk `@@ -90,15 +91,29 @@` which added
`let pre = if !is_object_safe { format!("`{trait_name}` is not object safe, ") } ...` and `format!("{pre}use `impl ...`")`.
Pre-fix, the message had no such prefix, so the suggestion omitted the object-safety info.
