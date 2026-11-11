# Adapted injection for safe transmute: support `Variants::Single` enums

Fix: https://github.com/rust-lang/rust/commit/fb662f2126b026c91ddbc17ac3bdb8bd2bf575c5

# Rationale
File: compiler/rustc_transmute/src/layout/tree.rs, `Tree::from_enum` (re-expresses fix hunk `@@ -331,30 +331,63 @@ pub(crate) mod rustc`, which split enum handling into uninhabited / Single / Multiple).
- Removed the `if variant_layout.is_uninhabited() { return Ok(Self::uninhabited()) }` early return in `layout_of_variant` (the guard that keeps from_variant off nonexistent variants).
- `Variants::Single { index }` arm now iterates over all `def.discriminants()` like the Multiple arm (instead of delegating to `layout_of_variant(*index)`), i.e. Single and Multiple are treated identically, as before the fix. This calls tag_for_variant / from_variant on variants that don't exist in the layout, causing the ICE from #125811.
The discriminant.rs hunk (removing an assert) has no equivalent in 1.99.1 (assert already gone), so it was not touched.
