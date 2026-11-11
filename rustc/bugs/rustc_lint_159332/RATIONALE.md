# Adapted injection for Honor field-level lint attributes in non_snake_case

Fix: https://github.com/rust-lang/rust/commit/e54776fbdb9c233ebbc164fbb9f97e82f879f28c

Fix hunk `@@ -452,10 +452,8 @@ impl LateLintPass for NonSnakeCase` replaced `check_struct_def` (loop over s.fields()) with `check_field_def`.
Reversed in nonstandard_style.rs (NonSnakeCase): back to `check_struct_def` looping over fields. The field check then runs in the struct's lint-attr scope, not the field's, so field-level #[expect]/#[allow] are ignored.
Since 1.99.1 no longer had a `check_struct_def` lint hook, I re-added it: passes.rs (`fn check_struct_def(a: &VariantData)` in the late pass list) and late.rs `visit_variant_data` (`lint_callback!(self, check_struct_def, s)`). Supporting plumbing for the same hunk.
