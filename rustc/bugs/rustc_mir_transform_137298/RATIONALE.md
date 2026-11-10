# Adapted injection for Check signature WF when lowering MIR body

Fix: https://github.com/rust-lang/rust/commit/9d3d5a7fbb9d28d91e2d19d2b0bf5bc5af5b038c

# Hunk: compiler/rustc_mir_transform/src/lib.rs, `mir_drops_elaborated_and_const_checked`
Removed the block that taints the MIR body when the typeck root item (Fn/AssocFn/Static/Const/AssocConst) fails `check_well_formed`.
Re-expresses fix hunk `@@ -513,6 +513,24 @@ fn mir_drops_elaborated_and_const_checked` (added "Also taint the body if it's within a top-level item that is not well formed" + `tcx.check_well_formed(root)` -> `body.tainted_by_errors`).
The wfcheck.rs hunk (`unreachable!("{node:?}")`) is only a diagnostic message and was not reverted.
