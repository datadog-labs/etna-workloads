# Adapted injection for Fix trait method resolution on an adjusted never type

Fix: https://github.com/rust-lang/rust/commit/2f44f6c6d038f818c6e8e874227b7639ae4f11ba

# Rationale
File: compiler/rustc_hir_typeck/src/method/probe.rs, fn probe_op (the `if let Some(bad_ty) = &steps.opt_bad_ty` block).
Removed the branch `else if let ty::Infer(ty::TyVar(ty_id)) = *ty.kind() && ... diverging_type_vars ... { lint; demand_eqtype(span, root_ty, never) }`.
This re-expresses fix hunk `@@ -482,15 +491,20 @@` which added that branch (with "demand the type to be equal to the never type, so we can probe the never type for methods", issue #143349). Without it, a method call on an inference var adjusted from `!` falls to the "type annotations needed" error (E0282). The first fix hunk (hoisting the ty instantiation) is already in 1.99.1 and is harmless, left as is.
