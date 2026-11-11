# Adapted injection for Fix for async drop ice with partly dropped tuple

Fix: https://github.com/rust-lang/rust/commit/cce706ec3c4ed38ecaffc61dac3b835038cdc50b

# Rationale
compiler/rustc_mir_transform/src/elaborate_drop.rs, `DropCtxt::build_drop`: the cleanup check
`!self.elaborator.patch_ref().block(body, bb).is_cleanup` is reverted to `!self.elaborator.body()[bb].is_cleanup`.
Re-expresses fix hunk `@@ -376,7 +376,7 @@` (`-  && !self.elaborator.body()[bb].is_cleanup` / `+ ... patch_ref().block(...)`).
`bb` may be a newly patched block (index >= body.basic_blocks.len()), so indexing the body panics (ICE).
The patch.rs hunks (adding MirPatch::block helper) are refactors; the helper is left in place (still used), so no change.
