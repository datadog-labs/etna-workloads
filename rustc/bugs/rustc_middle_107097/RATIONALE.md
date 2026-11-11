# Adapted injection for Fix def-use dominance check

Fix: https://github.com/rust-lang/rust/commit/e489971902c814e5adb7041d1bda230a1acb4fd7

# Rationale
File: compiler/rustc_middle/src/mir/mod.rs, `DefLocation::dominates` (the logic moved here from rustc_codegen_ssa/src/mir/analyze.rs).
Re-expresses fix hunk `@@ -64,7 +64,22 @@ enum LocalKind` / `impl DefLocation { fn dominates ... DefLocation::Body(def) => def.successor_within_block().dominates(location, dominators)`.
Bug: the def location is compared directly (`def.dominates(location, ..)`) instead of `def.successor_within_block()`, so a def is treated as dominating a use in the same statement (`x = x + a`), causing "use before def" ICE in codegen.
