# Adapted injection for fix: Check the fallback map before queueing child in `visible_parent_map` BFS

Fix: https://github.com/rust-lang/rust/commit/640032da529931144e4a38b749bf02a551f72bfd

# Re-injected bug

File/function: compiler/rustc_metadata/src/rmeta/decoder/cstore_impl.rs, `visible_parent_map` provider, `add_child` closure, `Entry::Vacant` arm.

In 1.99.1 the fallback map was already a map (`FxHashMap`) and the merge loop differs from the fix, so only the BFS hunk applies.
It re-expresses the fix hunk `@@ -533,14 +534,24 @@ ... Entry::Vacant(entry) => {`.
The fix added an early `if fallback_map.contains_key(&def_id) { return; }` before the child is queued, with the comment "Make sure that we have not already explored this child through a previous fallback entry". I removed that check and restored the old `if fallback { fallback_map.insert(..) } else { entry.insert(parent) }` shape.
Effect: a child already reached through a fallback (doc-hidden) entry is re-queued and its fallback parent is overwritten, so the shortest hidden re-export path is no longer preferred.
