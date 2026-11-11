# Adapted injection for Improve proc macro attribute diagnostics

Fix: https://github.com/rust-lang/rust/commit/f92000816e0cf8bdfe6ad422464ce0fa6144b496

One hunk: compiler/rustc_passes/src/check_attr.rs, `CheckAttrVisitor::check_proc_macro`.
Removed `self.abort.set(true)` after emitting the bad-signature diagnostic (`diag.emit()`).
Re-expresses the fix hunk `@@ -2214,12 +2329,15 @@ fn check_mod_attrs` (adds `abort: Cell<bool>`, and
`if check_attr_visitor.abort.get() { tcx.sess.abort_if_errors() }`) and the `self.abort.set(true)` calls in
check_proc_macro: without aborting after a bad proc-macro signature, compilation continues and later
passes emit the confusing extra errors the fix was meant to suppress (#102923).
