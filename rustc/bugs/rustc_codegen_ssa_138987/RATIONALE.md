# Adapted injection for Always emit native-static-libs note, even if it is empty

Fix: https://github.com/rust-lang/rust/commit/d1cd621b55a7def094f5cfecb99d2909b2d0e701

# Rationale
File compiler/rustc_codegen_ssa/src/back/link.rs, fn print_native_static_libs.
Re-adds `if !lib_args.is_empty() { ... }` guards around the note emission in both the
`OutFileName::Real` and `OutFileName::Stdout` arms, reversing fix hunk
`@@ -1560,17 +1560,13 @@ fn print_native_static_libs(` (which removed those guards). With the guards, an empty
lib list emits no `native-static-libs:` note.
