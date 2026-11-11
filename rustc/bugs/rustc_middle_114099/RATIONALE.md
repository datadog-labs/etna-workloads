# Adapted injection for privacy: no nominal visibility for assoc fns

Fix: https://github.com/rust-lang/rust/commit/e051a323110d438c337f3f893d171fade7d2d1a6

# Rationale
File: compiler/rustc_middle/src/middle/privacy.rs, `EffectiveVisibilities::check_invariants`.
Re-expresses fix hunk `@@ -178,7 +178,12 @@ impl EffectiveVisibilities`: the fix added `is_associated_item_in_trait_impl` and changed the condition to `if !is_impl && !is_associated_item_in_trait_impl`. In 1.99.1 that is `!is_impl && tcx.trait_impl_of_assoc(def_id.to_def_id()).is_none()`; I removed the second conjunct so the reachable <= nominal check again applies to trait impl assoc items (the buggy parent behaviour). The second hunk (trailing comma) is cosmetic.
