# Adapted injection for fix ICE in pretty-printing `global_asm!`

Fix: https://github.com/rust-lang/rust/commit/9213cb80c29941a7fb752413613c2c68f7e7d7b3

compiler/rustc_middle/src/mir/pretty.rs, write_mir_sig: removed the arm `(DefKind::GlobalAsm, _) => {}` (with its comment "`global_asm!` have fake bodies..."), re-expressing fix hunk `@@ -653,7 +653,10 @@ fn write_mir_sig`. Dumping MIR for global_asm now hits `bug!("Unexpected def kind")` (ICE).
