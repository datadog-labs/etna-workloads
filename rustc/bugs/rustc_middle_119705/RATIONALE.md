# Adapted injection for effects: support ~const in assoc fns in trait impls

Fix: https://github.com/rust-lang/rust/commit/3acc5a0da327777b2e4a39a500a17546545dc569

# Rationale
The fix's ast_lowering hunks (`@@ -572,23 +573,25 @@` in compiler/rustc_ast_lowering/src/item.rs: `host_param_id` was only set for `ItemKind::Trait` parents, and the fix also set it for `ItemKind::Impl`, so `~const` bounds on assoc fns in trait impls got the host effect param) no longer exist in 1.99.1; the effects/host-param machinery was replaced by `[const]` conditional constness.
The equivalent in 1.99.1 is `TyCtxt::is_conditionally_const` (compiler/rustc_middle/src/ty/mod.rs), `DefKind::AssocFn` with parent `Impl { of_trait: true }`. I changed it to return `false`, i.e. trait-impl assoc fns are never conditionally const (previously: true when the trait method is conditionally const and the impl is). This restores the bug: `[const]` bounds on trait impl methods are unsupported/mis-handled (issue #119700).
