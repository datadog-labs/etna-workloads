# Adapted injection for fix

Fix: https://github.com/rust-lang/rust/commit/81a3c7598ca21e1c89344853f8af6bea4dbb28a8

In 1.99.1 the fix's recovery code already existed; I removed its call site.

- compiler/rustc_parse/src/parser/item.rs, parse_item_impl: removed the `generics_snapshot` creation (fix hunk `@@ -662,11 +662,20 @@`, the `look_ahead ... create_snapshot_for_diagnostic()` block) and the `.map_err(|e| ... snapshot.maybe_type_in_generic_parameter(e))` (fix hunk `@@ -698,9 +707,13 @@`), restoring plain `self.parse_ty_with_generics_recovery(&generics)?`.
- compiler/rustc_parse/src/parser/diagnostics.rs: added `#[allow(dead_code)]` on `maybe_type_in_generic_parameter` so the now-unused function does not warn. Not a behaviour change.
