# Adapted injection for Allow struct field default values to reference struct's generics

Fix: https://github.com/rust-lang/rust/commit/3e5fddc95ea2d8851def90b940030d1c97bd5b00

Hunk: compiler/rustc_hir_analysis/src/collect/generics_of.rs, generics_of (anon const parent match).
Fix hunk `@@ -187,6 +187,8 @@` added `Node::Field(_) => Some(parent_did)` ("Field default values inherit the ADT's generics"). In 1.99.1 this lives in the NonTypeSystemAnon arm as `matches!(parent_hir_node, Node::TyPat(_) | Node::Field(_))`; I removed `| Node::Field(_)`, so field default anon consts have no parent generics again.
(The late.rs hunks of the fix are already differently shaped; left as-is, this one change is enough.)
