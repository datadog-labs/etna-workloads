# Adapted injection for Avoid misleading closure return type note

Fix: https://github.com/rust-lang/rust/commit/5e00484c38c2ce8084f081678afe47474dbe85ad

# Rationale
File compiler/rustc_hir_typeck/src/coercion.rs, fn report_return_mismatched_types.
Fix hunk: `@@ -2009,6 +2009,9 @@ impl<'tcx> CoerceMany<'tcx>` added a guard (expected ret_coercion type == `expected`) before emitting "return type inferred to be `{expected}` here". In 1.99.1 that guard is expressed as the `is_return_position` check (the block is the fn's return block). I removed that check (and its now-unused variable), so the note is emitted again for a block that isn't the closure's return, reproducing the misleading note.
