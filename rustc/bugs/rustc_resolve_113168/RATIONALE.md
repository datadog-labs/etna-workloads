# Adapted injection for fix(resolve): skip assertion judgment when `NonModule` is dummy

Fix: https://github.com/rust-lang/rust/commit/549f48d0ede94ab53056830cf9d5189c0445428e

compiler/rustc_resolve/src/imports.rs, finalize_import, `PathResult::NonModule` arm: removed the dummy-result guard so the assertion `import.imported_module.get().is_none()` runs even when the partial result is `Res::Err`. Re-expresses hunk `@@ -894,8 +894,9 @@` in imports.rs (`PathResult::NonModule(partial_res)` / `if no_ambiguity && partial_res.full_res() != Some(Res::Err)`), restoring `PathResult::NonModule(_)` / `if no_ambiguity`. The other fix hunks (instrument skip, derive Debug) are not behavioural.
