# Adapted injection for Fix #[inline(always)] on closures with target feature 1.1

Fix: https://github.com/rust-lang/rust/commit/ddb16e2884cdfe3c1c7eff8a431d1165213f7842

compiler/rustc_codegen_ssa/src/codegen_attrs.rs, apply_overrides: closure target-feature inheritance (`#73631`).
Re-expresses fix hunk `@@ -493,7 +493,22 @@ fn codegen_fn_attrs`, which added `&& codegen_fn_attrs.inline != InlineAttr::Always`
to the closure-inherits-target_feature condition. I removed that condition, so `#[inline(always)]` closures inherit target features again.
