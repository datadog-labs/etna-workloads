# Adapted injection for resolve: Stop feeding visibilities for import list stems

Fix: https://github.com/rust-lang/rust/commit/006e0ef18ddd1f4f9de4d528369ebe8b564eb18d

# Rationale
File compiler/rustc_resolve/src/build_reduced_graph.rs, fn build_reduced_graph_for_use_tree (line ~605).
Changed `if nested && !list_stem {` back to `if nested {`, re-expressing fix hunk
`@@ -404,7 +405,9 @@ ... -        if nested {  +        if nested && !list_stem {`.
List stems (which reuse the parent use tree's id) get their visibility fed a second time again.
The `list_stem` parameter and call sites are left in place (now unused), as only the guard matters.
