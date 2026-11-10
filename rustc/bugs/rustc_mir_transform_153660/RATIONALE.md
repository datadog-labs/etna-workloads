# Adapted injection for mir-opt: Drop invalid debuginfos after SingleUseConsts.

Fix: https://github.com/rust-lang/rust/commit/86da9312dc68ffb72cd1d28a99946dc4d37690c1

Hunk: compiler/rustc_mir_transform/src/single_use_consts.rs, `SingleUseConsts::run_pass`.
Removed the trailing `drop_invalid_debuginfos(body);` call and its `use crate::strip_debuginfo::drop_invalid_debuginfos;` import.
Re-expresses fix hunks `@@ -82,6 +84,8 @@` (added `drop_invalid_debuginfos(body);`) and `@@ -5,6 +5,8 @@` (added the import).
After SingleUseConsts removes locals from var_debug_info, stale StmtDebugInfo (DBG) entries remain.
The statement.rs/strip_debuginfo.rs refactor hunks are only helper refactoring; left as-is (the helper still exists, used by StripDebugInfo).
