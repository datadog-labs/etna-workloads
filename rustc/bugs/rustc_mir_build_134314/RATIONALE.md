# Adapted injection for Make sure to use normalized ty for unevaluated const for default struct value

Fix: https://github.com/rust-lang/rust/commit/f870761cd861ed222c5573cdd5abb99f4b9ba6d8

# Rationale
File: compiler/rustc_mir_build/src/builder/expr/into.rs (moved from build/expr/into.rs), `expr_into_dest`, `AdtExprBase::DefaultFields` arm.

Re-expresses fix hunk `@@ -367,14 +367,20 @@ impl<'a, 'tcx> Builder<'a, 'tcx>`: the fixed code builds
`Const::Unevaluated(UnevaluatedConst::new(def, args), ty)` using the normalized field type `ty` from `fru_field_types`.
The buggy (old) code is restored: `Const::from_unevaluated(tcx, def).instantiate(tcx, args)` + `literal_operand`,
which takes the un-normalized type from the const's declared type. (`.skip_norm_wip()` added only because 1.99.1's
`instantiate` returns `Unnormalized<..>`.) The `ty` binding is now unused for the value.
