# Adapted injection for Do not attempt to write `ty::Err` on binding that isn't from current HIR Owner

Fix: https://github.com/rust-lang/rust/commit/d54e9833e3513958a9e03c5f50b9496c618ebde5

# Rationale
File compiler/rustc_hir_typeck/src/fn_ctxt/checks.rs, fn `overwrite_local_ty_if_err` (was the `@@ -1916,18 +1916,11 @@` code in fix.diff, now moved).
The fix removed `tcx` and `type NestedFilter = nested_filter::All` / `nested_visit_map` from the pattern visitor `V`
(so it no longer visits nested bodies). Re-injected: visitor `OverwritePatternsWithError` again holds `tcx`, uses NestedFilter=All
and `maybe_tcx` (1.99 equivalent of nested_visit_map), and is built with `tcx: self.tcx` (second hunk `V { tcx: self.tcx, ... }`).
Result: nested-body patterns from other HIR owners get `write_ty` of ty::Err -> ICE.
