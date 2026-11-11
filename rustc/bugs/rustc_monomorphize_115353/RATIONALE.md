# Adapted injection for Emit error instead of ICE when optimized MIR is missing

Fix: https://github.com/rust-lang/rust/commit/456007af125d3822285135659ea5ea0b67084b66

# Hunk: compiler/rustc_monomorphize/src/collector.rs, `should_codegen_locally`
Fix hunk `@@ -950,7 +951,10 @@ fn should_codegen_locally`: replaced `bug!("no MIR available for {:?}", def_id);`
with `tcx.sess.emit_fatal(NoOptimizedMir {..})`. In 1.99.1 the emit_fatal(NoOptimizedMir{..}) call sits under
`!tcx.is_mir_available(def_id) && !Ctor`; I restored `bug!("no MIR available for {:?}", def_id)` there (ICE again),
and dropped the now-unused `NoOptimizedMir` import (matches the fix's collector.rs import hunk). The diagnostic struct/ftl
(errors.rs / messages.ftl hunks) are left in place, unused.
