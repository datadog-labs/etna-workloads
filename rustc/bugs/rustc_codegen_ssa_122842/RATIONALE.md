# Adapted injection for Don't emit an error about failing to produce a file with a specific name

Fix: https://github.com/rust-lang/rust/commit/bf12aa49e71d6e444c34d7adb87647f36b7dde1a

# Rationale
File: compiler/rustc_codegen_ssa/src/back/write.rs, fn produce_final_output_artifacts (line ~551).
Fix hunk `@@ -592,7 +592,7 @@ fn produce_final_output_artifacts`:
`-if crate_output.outputs.contains_key(&output_type)` / `+...contains_explicit_name(...)`.
Re-injected by restoring `contains_key`, so the IgnoringEmitPath warning fires even when the user gave no explicit name (with codegen-units>1 and --emit asm). The config.rs helper (already present in 1.99.1) is left unused-by-this-site.
