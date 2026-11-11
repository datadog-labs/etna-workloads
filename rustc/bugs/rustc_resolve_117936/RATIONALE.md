# Adapted injection for Use the glob binding in resolve_rustdoc_path process

Fix: https://github.com/rust-lang/rust/commit/940473adb423cc5e1d77a4d3cffeb617283e337c

compiler/rustc_resolve/src/imports.rs, `import_dummy_binding`: removed the `update_local_resolution(..., |_, resolution| resolution.single_imports.swap_remove(&import))` call (and its underscore guard) after planting the dummy decl. This re-expresses the fix hunk `@@ -477,6 +477,9 @@ ... resolution.single_imports.remove(&import);` which added that removal after `try_define(..., dummy_binding, false)`.
