# Adapted injection for Collect items referenced from var_debug_info

Fix: https://github.com/rust-lang/rust/commit/b04e5b496323a8e0a7e4028bfb6252f348c10329

# Rationale
File compiler/rustc_monomorphize/src/collector.rs, fn collect_items_of_instance.
Removed the block (fix hunk `@@ -1235,6 +1235,11 @@ fn collect_items_of_instance`):
`if tcx.sess.opts.debuginfo == DebugInfo::Full { for var_debug_info in &body.var_debug_info { collector.visit_var_debug_info(var_debug_info); } }`
so items referenced only from var_debug_info (e.g. VarDebugInfoContents::Const) are not collected, and may be wrongly internalized.
Also removed `DebugInfo` from the import (fix hunk `@@ -231,7 +231,7 @@`: `use rustc_session::config::{DebugInfo, EntryFnType};`).
