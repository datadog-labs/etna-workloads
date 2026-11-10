# Adapted injection for Fix ICE-133063

Fix: https://github.com/rust-lang/rust/commit/3a83422c136533592618da1ec0a2abee0ef5e5d9

compiler/rustc_mir_build/src/builder/matches/mod.rs, fn `finalize_or_candidate` (the `if candidate.subcandidates.is_empty()` block, ~line 2080).
Re-expresses the fix hunk `@@ -2000,8 +2000,10 @@`: removes `candidate.otherwise_block = Some(next_block)`, so a leaf or-candidate whose subcandidates were all dropped (never patterns) only gets pre_binding_block and has no otherwise_block (-> unwrap panic/ICE).
