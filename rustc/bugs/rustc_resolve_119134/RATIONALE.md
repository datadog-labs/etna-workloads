# Adapted injection for resolve: Feed visibilities for unresolved trait impl items

Fix: https://github.com/rust-lang/rust/commit/7571f6f685d1d4f021ebfd0047ffb2531663652a

# Rationale
File compiler/rustc_resolve/src/late.rs, fn `check_trait_item` (formerly `check_trait_item` at ~3078 in the fix).
Fix hunk 1 `@@ -3078,17 +3078,25 @@` added `feed_visibility(self, module.def_id())` in the "could not find the method" error path and `feed_visibility(self, id_in_trait)` right after resolving the binding. I removed both calls (the closure is kept).
Fix hunk 2 `@@ -3112,8 +3120,6 @@` removed the feed in the successful-match arm (`let vis = ...; self.r.feed_visibility(...)`). I restored feeding there, as `feed_visibility(self, id_in_trait)` after `record_partial_res`. So visibility is only fed for correctly matched items; unresolved or kind-mismatched impl items get none.
