# Adapted injection for borrowck: wf-check fn item args

Fix: https://github.com/rust-lang/rust/commit/a3fe3bbb2c80d155e31230bb75078b44904051bc

# Rationale
File: compiler/rustc_borrowck/src/type_check/mod.rs, fn `visit_const_operand` (the `ty::FnDef(def_id, args)` branch of the TypeVerifier-style visitor).
Removed the `assert_eq!(tcx.trait_impl_of_assoc(def_id), None)` and the `self.prove_clauses(args.types().map(|ty| ClauseKind::WellFormed(ty.into())), locations, ConstraintCategory::Boring)` call, which re-expresses the fix hunk `@@ -406,6 +406,16 @@ impl ... Visitor for TypeVerifier` that added `assert!(!matches!(impl_of_method...))` and `self.cx.prove_predicates(args.types().map(WellFormed...))`. Without it, fn item generic args are not WF-checked in borrowck (old buggy behaviour).
