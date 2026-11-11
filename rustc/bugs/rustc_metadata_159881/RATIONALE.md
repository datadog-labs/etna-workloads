# Adapted injection for fix: Do not stop `visible_parent_map` breadth-first search reaching children of `#[doc(hidden)]` modules

Fix: https://github.com/rust-lang/rust/commit/e5b636479b89f1fcb3120cbdfa98532f513470ce

# Rationale
File: compiler/rustc_metadata/src/rmeta/decoder/cstore_impl.rs, `visible_parent_map` provider, closure `add_child`, `Entry::Vacant` branch.
Re-expresses fix hunk `@@ -519,20 +519,30 @@` (the comment "It is important to not return early in the fallback cases to ensure that we extend the BFS to the children of fallback items"). Added `return;` after `fallback_map.insert(def_id, parent);` so fallback (doc(hidden)/`_`) items are not pushed on the BFS queue, so their children are never reached (the old early-return behaviour).
