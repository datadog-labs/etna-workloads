# Adapted injection for Don't ICE on bound types in sized conditions

Fix: https://github.com/rust-lang/rust/commit/f4a4a3147955ceb359204d85a74e15ee9d98046b

# Rationale
File: compiler/rustc_trait_selection/src/traits/select/candidate_assembly.rs, fn `assemble_builtin_sized_candidate`.
The fix hunk (`@@ -2148,12 +2148,13 @@` in select/mod.rs, builtin_bound conditions) moved `ty::Bound(..)` out of the `bug!("asked to assemble builtin bounds of unexpected type")` arm into `ty::Bound(..) => None` ("We can make this an ICE if/once we actually instantiate"). In 1.99.1 that logic is the `ty::Bound(..) => {}` arm of the Sized candidate assembly; I merged it back into the `bug!` arm with the Fresh* types, restoring the ICE for `for<V> V: Sized`.
