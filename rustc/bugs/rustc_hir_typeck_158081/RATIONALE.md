# Adapted injection for Recover deferred closure calls after errors

Fix: https://github.com/rust-lang/rust/commit/9aaea562307a3b1866ba53d895fc13ab5073ea66

# Rationale
Only one hunk changed: compiler/rustc_hir_typeck/src/callee.rs, `DeferredCallResolution::resolve`, `None =>` arm.
Re-expresses fix hunk `@@ -1161,11 +1161,16 @@ impl<'a, 'tcx> DeferredCallResolution<'tcx>`: the fix replaced
`span_bug!(self.call_expr.span, "Expected to find a suitable Fn/FnMut/FnOnce implementation ...")` with
a tainted-by-errors / span_delayed_bug + `fcx.write_resolution(call_expr.hir_id, Err(guar))`. I restored the unconditional `span_bug!`
(and the `use rustc_middle::{bug, span_bug}` import, per the first hunk of the fix).
The suggestions.rs hunks (early return in closure-return suggestion) were not reapplied; not needed for the oracle to fail.
