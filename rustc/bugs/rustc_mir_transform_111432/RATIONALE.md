# Adapted injection for Use visit_assign to detect SSA locals.

Fix: https://github.com/rust-lang/rust/commit/6ad0497cc07eb7ed515605348ae7c56c25c89566

# Rationale
File compiler/rustc_mir_transform/src/ssa.rs, `SsaVisitor::visit_place`.
Fix hunk `@@ -252,6 +245,19 @@` added `visit_assign` that records an assignment only `if let Some(local) = place.as_local()`, otherwise visits the place as a normal Store (which makes the local `Many`). The pre-fix code recorded assignments in `visit_local` on any Store context, including partial stores like `x.0 = 1`.
In 1.99.1 the recording lives in `visit_place`, guarded by `place.as_local()`. I dropped that guard and use `place.local`, so a partial (projected) store counts as an SSA assignment to the whole local again.
