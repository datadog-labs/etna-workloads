# Adapted injection for Improve error messages for generics with default parameters

Fix: https://github.com/rust-lang/rust/commit/49961947c8a830fc1d5d4ecc5916267a7e4bb6b0

# Rationale
- compiler/rustc_trait_selection/src/error_reporting/infer/mod.rs, ADT arm of the type-diff code (`(&ty::Adt(def1, sub1), &ty::Adt(def2, sub2))`): restored the unconditional `generics_of(did).own_args_no_defaults(..)` for both sides, removing the `non_default_after_default` / `own_args` choice. Re-expresses the hunk `@@ -1247,10 +1247,23 @@ impl<'tcx> TypeErrCtxt` (fix added `check_concrete_type_after_default` and the `if non_default_after_default { own_args } else { own_args_no_defaults }`).
- compiler/rustc_middle/src/ty/generics.rs: removed `Generics::check_concrete_type_after_default` (hunk `@@ -360,6 +360,33 @@`), now unused.
