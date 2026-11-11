# Adapted injection for interpret: project_downcast: do not ICE for uninhabited variants

Fix: https://github.com/rust-lang/rust/commit/1025a12b64a7e5d852e02d59d86aca558733bed1

# Hunk: compiler/rustc_const_eval/src/interpret/projection.rs, `project_downcast`
Re-expresses fix hunk `@@ -201,25 +201,8 @@` which removed `assert!(!layout.abi.is_uninhabited());` and replaced it with the comment "This variant may in fact be uninhabited". I restored the assert as `assert!(!layout.is_uninhabited());` (the ABI accessor changed in 1.99.1). Downcasting to an uninhabited variant now ICEs.
(The syntax.rs hunk is doc-only.)
