# Adapted injection for Trace `?id.local_def_index` instead of `id` in `def_path_hash`

Fix: https://github.com/rust-lang/rust/commit/6fac60de91b53010acf8531de39caa36164ee51c

# Hunk
File: compiler/rustc_hir_id/src/definitions.rs (moved from rustc_hir), `Definitions::def_path_hash`.
Restored the old attribute `#[instrument(level = "trace", skip(self), ret)]`, removing the comment and
`skip(self, id), fields(def_index=?id.local_def_index)`. Reverses fix hunk
`@@ -252,7 +252,9 @@ impl Definitions` (`-#[instrument(level = "trace", skip(self), ret)]` / `+...skip(self, id), fields(def_index=?id.local_def_index)...`).
With RUSTC_LOG=trace, `id: LocalDefId` is Debug-formatted too early, causing an ICE/error.
