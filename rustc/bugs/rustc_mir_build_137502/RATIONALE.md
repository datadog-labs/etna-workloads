# Adapted injection for Construct MIR error body for global_asm correctly

Fix: https://github.com/rust-lang/rust/commit/c867b8f11dbf0be397ba9b5c898fde95f8d5ea6c

# Rationale
File compiler/rustc_mir_build/src/builder/mod.rs, fn construct_error: removed `| DefKind::GlobalAsm` from the
const-like arm `(vec![], type_of(def_id)..., None)`. Re-expresses fix hunk
`@@ -612,7 +612,8 @@ fn construct_error` which added `| DefKind::GlobalAsm` to that arm. Without it, a global_asm with errors hits the unreachable fallthrough and ICEs.
