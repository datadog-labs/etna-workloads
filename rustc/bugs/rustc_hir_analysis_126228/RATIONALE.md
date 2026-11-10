# Adapted injection for Correct parent for nested anon consts

Fix: https://github.com/rust-lang/rust/commit/bfb7757c3c059d3bbcfbc604ab326fa777be13aa

# Rationale
File: compiler/rustc_hir_analysis/src/collect/generics_of.rs, fn generics_of, `Node::AnonConst(_)` arm.
Fix hunk `@@ -66,7 +67,22 @@` replaced `let parent_def_id = tcx.hir().get_parent_item(hir_id);` with `tcx.parent(def_id)` (the DefId parent, e.g. an enclosing anon const). In 1.99.1 that is `let parent_did = tcx.local_parent(def_id);`; I restored the old behaviour: `let parent_did = tcx.hir_get_parent_item(hir_id).def_id;` (nearest enclosing item, skipping a parent anon const). All later uses of `parent_did` (the other hunks) already use the variable, so one line re-expresses them.
