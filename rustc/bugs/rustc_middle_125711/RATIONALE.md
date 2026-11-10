# Adapted injection for Make `body_owned_by` return the body directly.

Fix: https://github.com/rust-lang/rust/commit/a34c26e7ecfbfe3f4fd5fbd4868a0cba5676e6a5

# Rationale
Fix: `body_owned_by` returns the Body directly, synthesizing a Body for inline consts (hunk `@@ -254,13 +256,26 @@ impl<'hir> Map<'hir>` in rustc_middle/src/hir/map/mod.rs), and removes the InlineConst special case from `thir_body` (hunk `@@ -24,22 +24,7 @@ pub(crate) fn thir_body(` in rustc_mir_build/src/thir/cx/mod.rs).
In 1.99.1 the API is `hir_maybe_body_owned_by`/`hir_body_owned_by`; inline consts are `Node::ConstBlock`.

1. compiler/rustc_middle/src/hir/map.rs `hir_maybe_body_owned_by`: returns None for `Node::ConstBlock` (parent behaviour: inline consts have no body from body_owned_by; the fix added the `DefKind::InlineConst => Cow::Owned(Body{..})` arm).
2. compiler/rustc_mir_build/src/thir/cx/mod.rs `thir_body`: re-adds the special case for inline consts (the removed `DefKind::InlineConst => {... body = hir::Body{..}}` block), so THIR building still works; other callers using `hir_body_owned_by` on an inline const (e.g. MIR build/analysis) now ICE "body_owned_by: ... has no associated body".
