# Adapted injection for Check yield terminator's resume type in borrowck

Fix: https://github.com/rust-lang/rust/commit/1d48f69d65af74201314304623f37f5bcefa9a24

# Rationale
One hunk: compiler/rustc_borrowck/src/type_check/mod.rs, `TypeChecker::visit_terminator`, `TerminatorKind::Yield` arm.
Removed the `match self.body.resume_ty() { ... self.sub_types(ty, resume_ty.ty, ...) }` block and the `resume_arg` binding.
Re-expresses fix hunk `@@ -1450,13 +1450,13 @@` / `@@ -1474,6 +1474,28 @@` in type_check/mod.rs (`TerminatorKind::Yield { value, resume_arg, .. }` and the added resume-type `sub_types` check). Without it borrowck never relates the yield's resume place type to the coroutine resume type, so lifetime errors are missed.
The other fix hunks (resume_ty field, visitor, universal_regions, input_output) already exist in 1.99.1 and were left in place.
