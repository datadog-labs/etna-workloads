# Adapted injection for Fix ICE when opaque captures a duplicated/invalid lifetime

Fix: https://github.com/rust-lang/rust/commit/d3c60672755fd7c5bfaabaac3af88961712a2b9a

Reverted `ParamName::Error(Ident)` back to payload-less `ParamName::Error`, so an invalid/duplicated lifetime param loses its name (becomes `'_`) and the opaque's captured identity args mismatch -> ICE.
- compiler/rustc_hir/src/hir.rs (enum ParamName, ParamName::ident): re-expresses `@@ -52,6 +52,13 @@ pub enum ParamName` (`Error(Ident)` added) and `impl ParamName` hunk (`Plain(ident) | Error(ident) => ident`).
- compiler/rustc_ast_lowering/src/lib.rs (lower_generic_param_kind): re-expresses `@@ -1845,11 +1845,11 @@` (`ParamName::Error(ident)`; ident lowered up front) -> back to `ParamName::Error`, ident only for Plain.
- compiler/rustc_hir/src/intravisit.rs (walk_generic_param): `ParamName::Plain(ident) | ParamName::Error(ident)` -> `Error | Fresh => {}`.
- compiler/rustc_hir_analysis/src/check/wfcheck.rs (check_variances_for_type_defn): `hir::ParamName::Error(_) => {...}` -> `hir::ParamName::Error => {}`.
