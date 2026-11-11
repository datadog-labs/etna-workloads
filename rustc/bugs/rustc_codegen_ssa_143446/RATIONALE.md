# Adapted injection for use `--dynamic-list` for exporting executable symbols

Fix: https://github.com/rust-lang/rust/commit/bf6d29d55847614e677e6c5d6060d2dc0b1ad47b

# Rationale
File: compiler/rustc_codegen_ssa/src/back/linker.rs, `GccLinker::export_symbols`.
Removed the `else if crate_type == CrateType::Executable && !self.sess.target.is_like_solaris { ... --dynamic-list ... }` branch.
This re-expresses the fix hunk `@@ -835,6 +834,21 @@` which added that branch (writes `{ sym; ... };` and passes `--dynamic-list`).
Without it, executables with -Zexport-executable-symbols fall into the version-script branch (`global: ...; local: *;` + `--version-script`), the pre-fix behaviour, so symbols aren't exported dynamically (issue 101610).
The other hunks were just refactors (moving link_arg calls); 1.99.1 already has them inline.
