# Adapted injection for Make get_return_block() return Some only for HIR nodes in body

Fix: https://github.com/rust-lang/rust/commit/136f0579d8a6cfacbdbfbac4c6a10b8447fcdf9e

# Hunk: compiler/rustc_middle/src/hir/map.rs, `hir_get_fn_id_for_return_block`
The fix (`@@ -715,7 +717,14 @@` in rustc_middle/src/hir/map/mod.rs) made `get_return_block` return Some(fn) only when the
input node is inside the fn's body (`node.body_id().map(|b| b.hir_id) == prev_hir_id`), not e.g. in the return type.
In 1.99.1 this function was rewritten around `hir_enclosing_body_owner`, which yields the anon const for nodes inside a
const in a signature (so no fn is returned). I re-introduced the bug by skipping `AnonConst` when picking the enclosing
body owner, so nodes inside anon consts in a return type are attributed to the enclosing fn again.
