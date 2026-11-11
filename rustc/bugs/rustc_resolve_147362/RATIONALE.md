# Adapted injection for Avoid suggesting constrain the associated type to a trait

Fix: https://github.com/rust-lang/rust/commit/76bd555913eb9d363bf76136e1767f08f2c06bdb

# Rationale
File compiler/rustc_resolve/src/late/diagnostics.rs, function suggesting "constrain the associated type to `{ident}`" (where the `ident.span == span` check lives).
Re-expresses fix hunk `@@ -1572,26 +1572,31 @@`: the fix added, before building the suggestion,
`let Some(partial_res) = self.r.partial_res_map.get(&id) ... if !matches!(partial_res.full_res(), Some(Res::Def(..))) { return false; }`
and bound `id` in the segment pattern. I removed that resolution check (and changed `id` to `..`), so the suggestion is emitted even when the trait failed to resolve (e.g. `Debug` derive macro / unknown name).
