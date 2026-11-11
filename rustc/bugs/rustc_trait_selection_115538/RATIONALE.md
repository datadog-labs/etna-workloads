# Adapted injection for check `FnDef` return type for WF

Fix: https://github.com/rust-lang/rust/commit/2b67f0104a9fcdb3a6aa41bceb33e62e609e6b6c

# Rationale
File compiler/rustc_trait_selection/src/traits/wf.rs, fn `visit_ty` in WfPredicates, arm `ty::FnDef(did, args)`.
Removed the block that checks the FnDef return type for WF (`fn_sig.output().skip_binder().visit_with(self)`).
Re-expresses fix hunk `@@ -707,6 +709,16 @@` which added the "HACK: Check the return type of function definitions for well-formedness to mostly fix #84533" block.
The other hunks (self.tcx() -> tcx) are refactoring only and were not needed.
