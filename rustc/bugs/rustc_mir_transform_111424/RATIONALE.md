# Adapted injection for Don't inline functions with unsized args

Fix: https://github.com/rust-lang/rust/commit/60cc72cf7be596650a0dac5f74887f7e4eefae40

Hunk: compiler/rustc_mir_transform/src/inline.rs, fn try_inlining (free fn taking `inliner`).
Removed the `for arg in args { if !arg.node.ty(..).is_sized(..) { return Err("call has unsized argument") } }` loop
(the terminator/args/destination_ty lets are kept since later code uses them).
Re-expresses fix hunk `@@ -168,6 +168,18 @@ impl<'tcx> Inliner<'tcx>` which added the "Call has unsized argument" check; without it, functions with unsized args get inlined.
