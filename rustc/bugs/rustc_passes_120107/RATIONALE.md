# Adapted injection for `dead_code` treats `#[repr(transparent)]` the same as `#[repr(C)]`

Fix: https://github.com/rust-lang/rust/commit/d95d6ceecb372c66ed18a4e7a0bbb79e74ee8fed

compiler/rustc_passes/src/dead.rs, MarkSymbolVisitor::visit_node (Struct/Union arm): fix hunk
`@@ -365,15 +365,17 @@` set `repr_unconditionally_treats_fields_as_live = def.repr().c() || def.repr().transparent();`.
Re-injected the bug by dropping `|| def.repr().transparent()`, so only repr(C) marks fields live (the field was already renamed to the new name in 1.99.1; other hunks were pure renames).
