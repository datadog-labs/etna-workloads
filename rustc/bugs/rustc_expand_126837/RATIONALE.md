# Adapted injection for delegation: Do not crash on qpaths without a trait

Fix: https://github.com/rust-lang/rust/commit/0a265957ddebf3517e5d1105541ba7931d1974bb

# Rationale
File: compiler/rustc_expand/src/expand.rs, fn flat_map_node (delegation branch).
Re-expresses hunks `@@ -1989,6 +1990,8 @@` (the `let traitless_qself = matches!(&deleg.qself, Some(qself) if qself.position == 0);`) and `@@ -2000,6 +2003,11 @@` (`if traitless_qself { emit_err(GlobDelegationTraitlessQpath); return Default::default(); }`) by removing both, plus the now-unused import (import hunk @@ -1,8 +1,9 @@).
Without the check, traitless qpath glob delegation (`reuse <u8>::*;`) proceeds to collect_glob_delegation (the old crashing/wrong behaviour). The error struct/ftl were left in place (harmless).
