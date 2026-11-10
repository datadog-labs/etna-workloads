# Adapted injection for expand: Change how `#![cfg(FALSE)]` behaves on crate root

Fix: https://github.com/rust-lang/rust/commit/46becfdf9c807e0108a78bb4df9b8330b10422c8

# Rationale
1. compiler/rustc_expand/src/config.rs `pre_configure_attrs`: restored the old logic (collect all attrs, return empty AttrVec if `in_cfg` is false) instead of `take_while(!is_cfg || cfg_true)`. Re-expresses fix hunk `@@ -197,9 +197,11 @@ pub fn pre_configure_attrs` (old: `if strip_unconfigured.in_cfg(&attrs) { attrs } else { ast::AttrVec::new() }`).
2. compiler/rustc_expand/src/expand.rs `impl InvocationCollectorNode for ast::Crate::expand_cfg_false`: `self.attrs.clear()` instead of `self.attrs.truncate(pos)`. Re-expresses hunk `@@ -1409,8 +1414,15 @@ impl InvocationCollectorNode for ast::Crate` (`-self.attrs.clear();` / `+self.attrs.truncate(pos);`). The `pos` parameter is kept (as `_pos`).
