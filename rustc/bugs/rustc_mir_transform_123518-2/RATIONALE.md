# Adapted injection for Rework the ByMoveBody shim to actually work correctly

Fix: https://github.com/rust-lang/rust/commit/3674032eb21d145992f1b8374e4ab201d606fbd9

# Rationale
File: compiler/rustc_mir_transform/src/coroutine/by_move_body.rs, fn coroutine_by_move_body_def_id (field_remapping closure).

Fix hunk `@@ -116,32 +115,76 @@` introduced the field remapping: `FieldIdx::from_usize(parent_field_idx + num_args)` and
`child_precise_captures` (bridging projections, for precise captures splitting a parent field).
The pre-fix code only peeled a deref on by-ref fields and never renumbered fields or applied extra projections.
Re-injected: remap uses `child_field_idx + num_args` (no renumbering) and bridging projections are `Vec::new()`.
