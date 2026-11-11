# Adapted injection for Relax recursive opaque type check

Fix: https://github.com/rust-lang/rust/commit/7db5f818531fe7f77853a66793584fe15bb464fc

# Rationale
File: compiler/rustc_hir_typeck/src/writeback.rs, fn `visit_opaque_types`.
Fix hunk `@@ -565,23 +563,9 @@ impl<'cx, 'tcx> WritebackCx` replaced a `RecursionChecker` visitor (any occurrence of the opaque anywhere in the hidden type => skip) with an exact check (`hidden_type.ty` is the opaque itself with identical args).
I restored the old behaviour: re-added a `RecursionChecker` TypeVisitor and `continue` whenever the hidden type mentions the opaque anywhere (e.g. `B<TestImpl>`), instead of only when it equals the opaque with the same args. The conflicting-definition error is therefore skipped.
The import hunks (@@ -3,7 / -11,13) are not needed: those imports already exist in 1.99.1.
