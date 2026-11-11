# Adapted injection for Never emit `vptr` for empty/auto traits

Fix: https://github.com/rust-lang/rust/commit/781bff049905d325bb877935978f1bce8ea6af86

# Hunk: compiler/rustc_trait_selection/src/traits/vtable.rs, prepare_vtable_segments_inner
Fix hunk `@@ -154,18 +154,17 @@ fn prepare_vtable_segments_inner`: the fix added `has_entries` and used
`emit_vptr: emit_vptr && has_entries && ...` plus `emit_vptr_on_new_entry |= has_entries`.
In 1.99.1 has_entries was computed over transitive supertraits. I reverted to the old code: `emit_vptr` is
not gated on has_entries (vptr emitted for empty/auto traits), and `emit_vptr_on_new_entry` is set only
when the trait itself has own entries.
