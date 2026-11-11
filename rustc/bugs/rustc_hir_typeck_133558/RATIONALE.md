# Adapted injection for Structurally resolve in probe_adt

Fix: https://github.com/rust-lang/rust/commit/0609b999681f9c807554bffe838288bda7efa3f1

# Rationale
One hunk: compiler/rustc_hir_typeck/src/fn_ctxt/mod.rs, `FnCtxt::probe_adt` (HirTyLowerer impl).

Fix hunk: `@@ -307,7 +307,11 @@` replaced `self.normalize(span, ty).ty_adt_def()` with
`if self.next_trait_solver() { self.try_structurally_resolve_type(span, ty).ty_adt_def() } else { self.normalize(...) }`.

On 1.99.1 plain `normalize` under the next solver already evaluates the projection eagerly, so just reverting to `normalize` does not reproduce the bug. The original buggy behaviour was that, in the next solver, the alias became an unresolved infer var plus a pending projection obligation (never structurally resolved), so `ty_adt_def()` returned None. I re-expressed that in the next-solver branch: create `next_ty_var`, register the ProjectionPredicate obligation, call `ty_adt_def()` on the var without structural resolution. Old solver path unchanged.
