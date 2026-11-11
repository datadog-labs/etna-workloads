# Adapted injection for Stricter check for a use of locals without storage

Fix: https://github.com/rust-lang/rust/commit/532080cfcccdfd853008c4452b283130b544c675

# Re-injection
File: compiler/rustc_mir_transform/src/lint.rs, `lint_body` and `Lint::visit_local`.
Re-expresses the fix hunks `@@ -60,8 +68,8 @@ ... visit_local`: the fix replaced `storage_liveness` (`MaybeStorageLive`, `!contains(local)`) with `maybe_storage_dead.get().contains(local)`. I reverted to the old check: a use fails only if the local is not in MaybeStorageLive. That misses locals that are *maybe* dead (live on one path, no storage on another), as in no-storage.rs.
Also removed the `MaybeStorageDead` cursor, its field and import (fix hunks 1, 2, 3, 4 `-use ...{MaybeStorageDead, MaybeStorageLive}`, `let maybe_storage_dead = ...`, `maybe_storage_dead,` field), since it would be unused.
