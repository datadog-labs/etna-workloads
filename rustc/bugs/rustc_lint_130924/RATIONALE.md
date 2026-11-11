# Adapted injection for Make clashing_extern_declarations considering generic args for ADT field

Fix: https://github.com/rust-lang/rust/commit/0bf928968bf442ba0e4d50e8d716edf2dd43cbbc

# Rationale
compiler/rustc_lint/src/foreign_modules.rs, `structurally_same_type_impl`, ADT arm.
Re-expresses both hunks of fix.diff:
- `@@ -280,7 +280,7 @@`: `(&Adt(a_def, a_gen_args), &Adt(b_def, b_gen_args))` reverted to `(&ty::Adt(a_def, _), &ty::Adt(b_def, _))`.
- `@@ -304,8 +304,8 @@`: `type_of(a_did).instantiate(tcx, a_gen_args)` reverted to `.instantiate_identity()` (same for b), so generic args are ignored when comparing fields.
