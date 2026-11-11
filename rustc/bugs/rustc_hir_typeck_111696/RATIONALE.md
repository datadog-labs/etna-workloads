# Adapted injection for don't skip inference for type in `offset_of!`

Fix: https://github.com/rust-lang/rust/commit/7cdb23b98a58a4e73ab1e4ca5e3bb7d04645bdd7

# Rationale
File: compiler/rustc_hir_typeck/src/writeback.rs, fn `visit_offset_of_container_types` (plus `use rustc_middle::span_bug;`).
Re-expresses fix hunk `@@ -692,15 +692,7 @@ impl<'cx, 'tcx> WritebackCx` in writeback.rs: the fix replaced
`if cfg!(debug_assertions) && container.has_infer() { span_bug!(... "writeback: `{:?}` has inference variables" ...) }`
with `let container = self.resolve(container, &hir_id);`. The code now skips `self.resolve` and restores the span_bug
check, so inference vars in `offset_of!` container types are not resolved/reported (ICE instead of "type annotations needed").
The as_rvalue.rs hunk (erase_regions removal) was not re-expressed.
