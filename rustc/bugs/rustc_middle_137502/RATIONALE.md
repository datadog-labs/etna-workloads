# Adapted injection for Exclude global_asm from mir_keys

Fix: https://github.com/rust-lang/rust/commit/ef031c854da6432c86ac14c438ab96c7e349d85f

# Rationale
Fix hunk: `@@ -316,6 +316,10 @@ fn mir_keys` in compiler/rustc_mir_transform/src/lib.rs, which added
`set.retain(|&def_id| !matches!(tcx.def_kind(def_id), DefKind::GlobalAsm));`

1. compiler/rustc_mir_transform/src/lib.rs, `mir_keys`: removed that retain (and its comment), so global_asm fake bodies are in mir_keys again (reversal of the fix hunk).
2. compiler/rustc_middle/src/mir/pretty.rs, `write_mir_sig`: removed the `(DefKind::GlobalAsm, _) => {}` arm, added later by commit 9213cb80c29 ("fix ICE in pretty-printing global_asm!"). It is not part of fix.diff, but it masks the restored bug on 1.99.1 (hunk 1 alone made no test fail); without it, `--emit=mir` hits `bug!("Unexpected def kind")` as in the original parent commit, failing the emit_mir oracle case.
