# Adapted injection for Stop doing weird index stuff in ElaborateBoxDerefs

Fix: https://github.com/rust-lang/rust/commit/2e52d6180724ee0cbd8b47bc7806a53bf13ab240

# Rationale
File: compiler/rustc_mir_transform/src/elaborate_box_derefs.rs, `ElaborateBoxDerefs::run_pass` (var_debug_info loop).
Re-expresses the single hunk `@@ -116,29 +116,30 @@` of fix.diff in reverse: restores the old "last_deref" index
bookkeeping (`for (i, (base, elem)) in ...enumerate()`, `get_or_insert_default()`,
`new_projections.extend_from_slice(&base.projection[last_deref..])`, `last_deref = i`, and the trailing
`extend_from_slice(&place.projection[last_deref..])`) instead of cloning the prefix and pushing each following elem.
This makes debuginfo projections wrong (the prefix before the first Box deref is lost/duplicated).
