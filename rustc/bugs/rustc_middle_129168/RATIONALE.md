# Adapted injection for Rewrite `get_fn_id_for_return_block`

Fix: https://github.com/rust-lang/rust/commit/ed6315b3fef4ebd9aee053d407eb746c3b1d58bf

One hunk: compiler/rustc_middle/src/hir/map.rs, `hir_get_fn_id_for_return_block` (was map/mod.rs `get_fn_id_for_return_block`).
Re-expresses fix hunk `@@ -554,53 +554,43 @@`: reverted to the old implementation, which walks parent_iter and returns the first enclosing Item/ForeignItem/TraitItem/ImplItem/Closure whose body is the previous node, instead of using `enclosing_body_owner` (so e.g. const blocks / anon consts yield wrong or no fn id).
